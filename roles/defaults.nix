{ config, pkgs, nix-auth,... }:

let
  system = pkgs.system;
in {
  #package config
  nixpkgs = {
    config = {
      allowUnfree = true;
    };

    overlays = import ../overlays;
  };

  programs.nix-index.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.kitty
    pkgs.vim
    nix-auth.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # add nerd fonts
  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.droid-sans-mono
    nerd-fonts.fira-code
    nerd-fonts.iosevka
  ];

  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
  };

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
  nix.settings = {
    experimental-features = "nix-command flakes";
  };
  nix.extraOptions = ''
    min-free = ${toString (10 * 1024 * 1024 * 1024)} # 10 GB
    max-free = ${toString (50 * 1024 * 1024 * 1024)} # 50 GB
  '';

  # 1. Inject the Umbrella certificate alongside standard internet certs
  security.pki.certificateFiles = [
    "/etc/nix/certs/Cisco_Secure_Access_Root_CA.cer"
  ];
  nix.settings.extra-sandbox-paths = [
    "/etc/nix/certs/Cisco_Secure_Access_Root_CA.cer"
  ];

  # 2. Force Nix-managed tools (curl, openssl, python, etc.) to use the combined bundle
  environment.variables = {
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    REQUEST_CA_BUNDLE = "/etc/ssl/certs/ca-certificates.crt";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
  };
  nix.envVars = {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
    NODE_EXTRA_CA_CERTS = "/etc/ssl/certs/ca-certificates.crt";
  };

  # 3. Belt-and-suspenders: also set the daemon-side Nix setting in
  #    /etc/nix/nix.conf, so fixed-output fetches (fetchFromGitHub, buildGoModule
  #    vendoring, flake inputs) trust the combined bundle even if the daemon's
  #    launchd environment is stale. nix-daemon reads this at startup, so it only
  #    takes effect after the daemon restarts (darwin-rebuild switch restarts it
  #    on a nix.conf change).
  nix.settings.ssl-cert-file = "/etc/ssl/certs/ca-certificates.crt";

  nix.optimise = {
    automatic = true;
    interval = { Hour = 12; Minute = 30; }; # Runs every day at 12:30 PM
  };

  nix.gc = {
    automatic = true;
    interval = { Hour = 3; Minute = 0; }; # Run every day at 3:00 AM
    options = "--delete-older-than 7d";   # Automatically purges older generations
  };
}
