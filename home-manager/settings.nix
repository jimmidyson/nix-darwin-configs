{ config, pkgs, home-manager, ... }:

{
  imports = [
    home-manager.darwinModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
}
