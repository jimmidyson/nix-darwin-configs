{ config, pkgs, home-manager, lib, ... }:

let
  system = pkgs.system;
  homeDir = config.home.homeDirectory;
in {
  imports = [
    ./base.nix
  ];

  nix = {
    package = lib.mkForce pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home.packages = [
    pkgs.colima
    pkgs.m-cli
    pkgs.pinentry_mac
  ];
}
