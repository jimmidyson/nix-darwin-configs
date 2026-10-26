# Overlays shared by every host. Imported by roles/defaults.nix for the
# nix-darwin hosts, and applied directly when instantiating nixpkgs for the
# standalone home-manager (Linux) hosts, which never evaluate the nix-darwin
# modules.
[
  (_final: prev: let
    # Cargo's vendor fetch verifies TLS with Python requests. The nix-daemon
    # copies its own NIX_SSL_CERT_FILE into that build, which is the previous
    # generation's bundle until this config is activated, and cacert's setup
    # hook keeps it. preBuild runs after that hook, so point it at a bundle
    # that already contains the Cisco root. Daemon and session env vars cannot
    # do this: they are not installed until the build succeeds.
    cargoCaBundle = prev.runCommand "ca-bundle-with-cisco.crt" { } ''
      cat ${prev.cacert}/etc/ssl/certs/ca-bundle.crt > $out
      echo >> $out
      cat ${../certs/cisco-secure-access-root-ca.crt} >> $out
    '';
    fetchCargoVendor = args: prev.rustPlatform.fetchCargoVendor (args // {
      preBuild = ''
        export NIX_SSL_CERT_FILE=${cargoCaBundle}
        export SSL_CERT_FILE="$NIX_SSL_CERT_FILE"
        export REQUESTS_CA_BUNDLE="$NIX_SSL_CERT_FILE"
        ${args.preBuild or ""}
      '';
    });
  in {
    rustPlatform = prev.rustPlatform // {
      inherit fetchCargoVendor;
      buildRustPackage = prev.rustPlatform.buildRustPackage.override {
        inherit fetchCargoVendor;
      };
    };
  })

  (_final: prev: {
    fzf-git-sh = prev.fzf-git-sh.overrideAttrs (oldAttrs: {
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace fzf-git.sh \
          --replace-fail '${prev.fzf}/bin/fzf-git-' 'fzf-git-'
      '';

      installCheckPhase = (oldAttrs.installCheckPhase or "") + ''
        ${prev.gnugrep}/bin/grep -Fq '${prev.fzf}/bin/fzf --height' \
          "$out/share/fzf-git-sh/fzf-git.sh"
        if ${prev.gnugrep}/bin/grep -Fq '${prev.fzf}/bin/fzf-git-' \
          "$out/share/fzf-git-sh/fzf-git.sh"; then
          echo "fzf-git widget identifiers contain the fzf store path" >&2
          exit 1
        fi
        ${prev.zsh}/bin/zsh -dfi -c '
          source "$out/share/fzf-git-sh/fzf-git.sh"
          typeset -f fzf-git-files-widget >/dev/null
        '
      '';
    });
  })
]
