{ config, pkgs, home-manager, nur, ... }:

{
  imports = [
    home-manager.darwinModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
}
