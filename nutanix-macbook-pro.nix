{ config, pkgs, home-manager, ... }:


let
  hostname = "H6GQ16XX6K";
  username = "jimmi.dyson";
in {
  imports = [
    roles/extra-platforms.nix
    roles/defaults.nix
    roles/brew.nix
    home-manager/settings.nix
  ];

  # Define user settings
  users.users.${username} = import roles/user.nix;

  # Home-Manager config
  home-manager = {
    # Set home-manager configs for username
    users.${username} = { ... }: {
      imports = [
        home-manager/darwin.nix
        home-manager/git.nix
        home-manager/programs.nix
        home-manager/zsh.nix
      ];
    };
  };

  # Set hostname
  networking.hostName = "${hostname}";

  # This value determines the Nix Darwin release from which the default
  # settings for stateful data were taken. It should never be changed after
  # the initial install (see nix-darwin docs for system.stateVersion).
  system.stateVersion = 4;

  system.primaryUser = "jimmi.dyson";
}
