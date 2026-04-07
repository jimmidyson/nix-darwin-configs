{ config, pkgs, home-manager, tuicr, troubleshoot-live, ... }:

{
  imports = [
    home-manager.darwinModules.home-manager
  ];
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.extraSpecialArgs = { inherit tuicr troubleshoot-live; };
}
