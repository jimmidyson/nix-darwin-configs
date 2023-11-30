{ config, pkgs, lib, home-manager, ... }:


let
  hostname = "V26M4P9FDJ";
  username = "jimmi.dyson";
in {
  imports = [
    roles/m1.nix
    roles/defaults.nix
    roles/brew.nix
    roles/yabai.nix
    roles/skhd.nix
    home-manager/settings.nix
  ];

  # Define user settings
  users.users.${username} = import roles/user.nix {
    inherit config;
    inherit pkgs;
  };

  # Home-Manager config
  home-manager = {
    # Set home-manager configs for username
    users.${username} = { ... }: {
      imports = [
        home-manager/darwin.nix
        home-manager/git.nix
      ];
    };
  };

  # Set hostname
  networking.hostName = "${hostname}";

  # Applications specific to this machine
  homebrew = {
    brews = [
    ];
    casks = [
    ];
  };

  system.stateVersion = 4;
}
