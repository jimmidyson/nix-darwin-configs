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
    # Built from source via naersk, so every crate comes from crates.io. The
    # Rocky box's corporate egress blocks crates.io outright, so this stays
    # darwin-only until that is allowlisted; moving it back to base.nix is the
    # only change needed then, since linux.nix already receives `tuicr` too.
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
