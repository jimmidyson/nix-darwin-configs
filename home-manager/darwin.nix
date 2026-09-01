{ config, pkgs, ... }:

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

  home.packages = with pkgs; [
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
  ];
}
