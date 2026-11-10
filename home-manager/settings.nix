{ home-manager, tuicr, ... }:
{
  imports = [
    home-manager.darwinModules.home-manager
  ];
  home-manager = {
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit tuicr; };
  };
}
