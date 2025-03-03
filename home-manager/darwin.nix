{ config, pkgs, home-manager, ... }:

let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {
  imports = [
    ./base.nix
  ];

  home.packages = [
    pkgs.colima
    pkgs.m-cli
    pkgs.pinentry_mac
  ];
}
