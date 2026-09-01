{ config, pkgs, lib, ... }:

# Nutanix Rocky Linux 8 VM (jimmi-dyson.r8.ubvm.nutanix.com).
#
# Nix is installed on top of the distro rather than the distro being NixOS, so
# there is no system-level module here: home-manager runs standalone and owns
# the user profile and dotfiles only. Anything needing root (packages in /usr,
# systemd units, the login shell) stays with dnf/systemctl.

let
  # Must match the actual account on the box: `id -un` and `echo $HOME`.
  username = "jimmi.dyson";
  homeDirectory = "/home/${username}";
in {
  imports = [
    home-manager/linux.nix
    home-manager/git.nix
    home-manager/programs.nix
    home-manager/zsh.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
}
