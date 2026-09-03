{ config, pkgs, tuicr, ... }:

let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {
  imports = [
    ./base.nix
  ];

  # Ghostty is the local terminal emulator, so it is only wanted on the machine
  # that has a display. Remote shells still get its integration via TERM.
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    enableZshIntegration = true;
  };

  home.packages = [
    # Built from source via naersk, so every crate comes from crates.io and
    # nothing has ever cached it. crates.io 403s nixpkgs' fetchurl User-Agent
    # (rust-lang/crates.io#13482), which the Linux host works around with a
    # NIX_CURL_FLAGS drop-in for nix-daemon — see README.md. Kept darwin-only
    # until that is in place there; linux.nix already receives `tuicr`, so
    # moving this back to base.nix is then the only change needed.
    tuicr.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ] ++ (with pkgs; [
    m-cli
    pinentry_mac

    # GUI applications.
    _1password-gui
    trilium-desktop

    # lima/VM tooling: only the mac runs Linux VMs.
    docker
    gvproxy
    libvirt
    qemu
  ]);
}
