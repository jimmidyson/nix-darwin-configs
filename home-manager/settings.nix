{ config, pkgs, home-manager, tuicr, ... }:

{
  imports = [
    home-manager.darwinModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit tuicr; };
}
