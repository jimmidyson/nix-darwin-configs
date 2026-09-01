# nix-darwin-configs

Nix configuration for my machines.

| Host | Platform | Managed by | Entry point |
| --- | --- | --- | --- |
| `V26M4P9FDJ` | `aarch64-darwin` | nix-darwin (+ home-manager as a nix-darwin module) | `nutanix-macbook-pro.nix` |
| `jimmi-dyson.r8.ubvm.nutanix.com` | `x86_64-linux` (Rocky 8) | standalone home-manager | `nutanix-linux-vm.nix` |

## Layout

```
flake.nix              darwinConfigurations + homeConfigurations
overlays/              nixpkgs overlays, shared by both platforms
pkgs/                  local packages not (yet) in nixpkgs
roles/                 nix-darwin system modules (macOS only)
home-manager/
  base.nix             cross-platform packages and nix settings
  darwin.nix           base.nix + macOS-only and GUI packages
  linux.nix            base.nix + non-NixOS Linux glue
  git.nix              \
  programs.nix          } cross-platform, imported by both hosts
  zsh.nix              /
  settings.nix         wires home-manager into nix-darwin (macOS only)
```

`base.nix`, `git.nix`, `programs.nix` and `zsh.nix` are evaluated on both
platforms, so anything macOS-specific in them is guarded with
`pkgs.stdenv.hostPlatform.isDarwin`.

## macOS

```sh
darwin-rebuild switch --flake .#V26M4P9FDJ
```

## Linux

The box is Rocky 8 with Nix installed on top of the distro (it is not NixOS),
so there is nothing for nix-darwin or a NixOS module to hook into.
home-manager runs **standalone**: it manages `~/.nix-profile` and dotfiles under
`~/.config`, and nothing else. Packages in `/usr`, systemd units and the login
shell stay with `dnf`/`systemctl`.

### One-time prerequisites

1. **Flakes.** The Nix installed for devbox may not have them on. Check:

   ```sh
   nix --version
   nix flake --help >/dev/null 2>&1 && echo "flakes ok" || echo "flakes off"
   ```

   If they are off, enable them daemon-wide (needs root):

   ```sh
   sudo mkdir -p /etc/nix
   echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
   sudo systemctl restart nix-daemon
   ```

   `home-manager/base.nix` also writes `~/.config/nix/nix.conf` with the same
   setting, but that only applies once the first activation has happened.

2. **Corporate TLS.** If `nix` cannot fetch from `cache.nixos.org` or GitHub,
   the daemon needs the corporate root CA. This is the Linux equivalent of the
   `security.pki.certificateFiles` block in `roles/defaults.nix`:

   ```sh
   sudo cp <corporate-root>.crt /etc/pki/ca-trust/source/anchors/
   sudo update-ca-trust extract
   echo 'ssl-cert-file = /etc/pki/tls/certs/ca-bundle.crt' | sudo tee -a /etc/nix/nix.conf
   sudo systemctl restart nix-daemon
   ```

   `home-manager/linux.nix` points `SSL_CERT_FILE` and friends at that same
   bundle for everything running in the shell.

### First activation

There is no `home-manager` command yet, so build the activation package
straight out of this flake and run it. This uses the home-manager pinned in
`flake.lock` rather than whatever the registry resolves to.

```sh
git clone <this repo> ~/src/nix-darwin-configs
cd ~/src/nix-darwin-configs

ATTR='homeConfigurations."jimmi.dyson@jimmi-dyson".activationPackage'
nix build --no-link ".#$ATTR"
HOME_MANAGER_BACKUP_EXT=backup "$(nix path-info ".#$ATTR")"/activate
```

The quoting matters: the attribute name contains a `.`, so it has to be
quoted inside the flake selector.

`HOME_MANAGER_BACKUP_EXT` is what `-b` sets on the CLI, and it is worth setting
here: activation refuses to clobber an existing unmanaged file, and the devbox
setup very likely already left a `~/.config/nix/nix.conf` and possibly a
`~/.zshenv`. With it set, those are moved aside to `*.backup` instead of
aborting the run.

### Every activation after that

`programs.home-manager.enable` put the CLI in the profile, and the attribute is
named `$USER@$(hostname -s)`, which home-manager looks up by itself:

```sh
cd ~/src/nix-darwin-configs
home-manager switch --flake .
```

Useful variations:

```sh
home-manager build --flake .          # build without activating
home-manager switch --flake . -b backup  # move clobbered files aside
home-manager generations              # list previous generations
nix flake update                      # bump all inputs
nix flake update home-manager         # bump one input
```

Roll back by running `activate` from an older generation listed by
`home-manager generations`.

### Giving the Nix store room

The store lives on `/`, and this box ships a 19G root. A full profile plus
devbox's own store fills it, and the failure mode is a build dying with
`no space left on device`.

Reclaim dead paths first — this is safe and usually the whole fix:

```sh
nix-collect-garbage -d        # your profiles and gcroots
sudo nix-collect-garbage -d   # everything unreachable, store-wide
du -sh /nix && df -h /
```

If the store genuinely needs more room, check for free extents in the volume
group before moving anything. Growing the root LV is far simpler and needs no
downtime:

```sh
sudo vgs                                        # look for free PE / VFree
sudo lvextend -r -l +100%FREE /dev/mapper/rocky-root
```

#### Relocating /nix to another volume

Only if the VG has nothing spare and a second disk is available. Store paths
are absolute, so the new volume must be mounted **at `/nix`** — not symlinked,
which breaks tools that resolve real paths.

```sh
# 1. Prepare the new volume and mount it somewhere temporary.
sudo mkfs.xfs /dev/sdb1
sudo mkdir -p /mnt/newnix && sudo mount /dev/sdb1 /mnt/newnix

# 2. Stop everything that touches the store. Exit any devbox/nix shells first.
sudo systemctl stop nix-daemon.service nix-daemon.socket

# 3. Copy. -H is essential: the store is heavily hardlinked by nix.optimise,
#    and without it the copy balloons. -AX carries ACLs and SELinux contexts.
sudo rsync -aHAX --numeric-ids --info=progress2 /nix/ /mnt/newnix/

# 4. Swap them, keeping the original until the new one is proven.
sudo umount /mnt/newnix
sudo mv /nix /nix.old && sudo mkdir /nix
echo "UUID=$(sudo blkid -s UUID -o value /dev/sdb1) /nix xfs defaults 0 2" \
  | sudo tee -a /etc/fstab
sudo mount /nix
sudo restorecon -R /nix          # SELinux is enforcing on Rocky
sudo systemctl start nix-daemon.socket

# 5. Verify before reclaiming anything.
nix store ping
nix build --no-link --print-out-paths nixpkgs#hello
ls /nix/store | wc -l            # compare against /nix.old

# 6. Only once the above is clean:
sudo rm -rf /nix.old
```

Step 6 is what actually frees space on `/`, so the win does not appear until
the old copy is gone. Keep it until you are satisfied.

### Source builds and the crates.io User-Agent block

Most of the closure comes from `cache.nixos.org`. A few packages cannot: they
are not in nixpkgs, so nothing has ever cached them and the daemon must fetch
their sources itself.

| Package | Fetches from |
| --- | --- |
| `tuicr` (flake input, naersk) | `crates.io` / `static.crates.io` |
| `pkgs/backport.nix` (buildNpmPackage) | `registry.npmjs.org`, `raw.githubusercontent.com` |
| `pkgs/troubleshoot-live.nix` (buildGoModule) | `github.com`, `proxy.golang.org` |

crates.io blocklists certain User-Agents — see
[rust-lang/crates.io#13482](https://github.com/rust-lang/crates.io/issues/13482).
nixpkgs' `fetchurl` identifies itself as `curl/<version> Nixpkgs/<version>`,
which gets a 403, so any crate download fails with:

```
curl: (22) The requested URL returned error: 403
error: cannot download download-filedescriptor-0.8.3 from any mirror
```

It looks like a network block but is not one: the 403 carries crates.io's own
Fastly headers (`via: 1.1 varnish`, `x-served-by: cache-*`), so the request
reached the real host and the host refused it. Any identifying User-Agent gets
a 302.

`fetchurl` appends `$NIX_CURL_FLAGS` *after* its own `--user-agent`, and curl
takes the last one, so overriding it fixes every fetch at once. The variable is
in `fetchurl`'s `impureEnvVars`, but it is read from **nix-daemon's**
environment rather than your shell, so it goes in a systemd drop-in:

```sh
sudo mkdir -p /etc/systemd/system/nix-daemon.service.d
sudo tee /etc/systemd/system/nix-daemon.service.d/curl-user-agent.conf <<'CONF'
[Service]
Environment=NIX_CURL_FLAGS=--user-agent jimmidyson-nixpkgs/1.0-jimmidyson@gmail.com
CONF
sudo systemctl daemon-reload && sudo systemctl restart nix-daemon
```

The User-Agent must contain **no spaces**: the builder expands
`$NIX_CURL_FLAGS` unquoted, so it is word-split and a quoted string with spaces
arrives as several broken arguments. crates.io's policy asks for a contact
address, so an email embedded in a space-free token satisfies both.

Verify with the package that fails first:

```sh
nix build --no-link --print-out-paths 'github:agavra/tuicr?ref=v0.9.0'
```

Other 403s worth telling apart before reaching for this:

- **403 while `env | grep -i proxy` shows a proxy** — the daemon is missing it.
  Same drop-in mechanism, with `Environment="https_proxy=..."` and friends;
  fixed-output derivations inherit proxy settings from the daemon, not you.
- **403 returned as a block page from an intermediary** — corporate filtering,
  which needs an allowlist request. That is not what is happening here.

### Making zsh the login shell

home-manager installs zsh into the profile but cannot change the login shell —
`chsh` only accepts shells listed in `/etc/shells`, and a Nix store path is not
there. Either:

```sh
# Option A: register the profile's zsh (needs root, and re-register after
# a zsh version bump because the store path changes).
command -v zsh | sudo tee -a /etc/shells
chsh -s "$(command -v zsh)"
```

or leave the login shell as bash and exec into zsh from `~/.bashrc`:

```sh
# Option B: no root needed.
if [[ $- == *i* && -z "$ZSH_VERSION" && -x "$HOME/.nix-profile/bin/zsh" ]]; then
  exec "$HOME/.nix-profile/bin/zsh" -l
fi
```

### Garbage collection

There is no `nix.gc` timer here because that is a root-level concern on a
non-NixOS box. The `nix-clean-system` and `nix-purge` aliases in `zsh.nix` do
the user-profile half:

```sh
home-manager expire-generations '-7 days'
nix-collect-garbage
```

## Adding another Linux host

Add a host file next to `nutanix-linux-vm.nix` importing `home-manager/linux.nix`,
then a `homeConfigurations."<user>@<short-hostname>"` entry in `flake.nix`.
