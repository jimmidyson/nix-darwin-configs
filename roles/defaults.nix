{ config, pkgs, ... }:

let
  system = pkgs.system;
in {
  #package config
  nixpkgs.config.allowUnfree = true;

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

  programs.zsh.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.kitty
    pkgs.vim
  ];

  # add nerd fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "Hack" "DroidSansMono" "Iosevka" ]; })
  ];

  #system-defaults.nix
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.defaults = {
    dock = {
      autohide = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      CreateDesktop = false;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };
   # Add flake support
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Use touch ID for sudo auth
  security.pam.enableSudoTouchIdAuth = true;
}
