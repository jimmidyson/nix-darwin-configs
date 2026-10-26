{ config, pkgs, nix-auth,... }:

let
  # nix-darwin concatenates this with the Mozilla bundle. Nix curl's OpenSSL
  # and nix-daemon both read it via NIX_SSL_CERT_FILE; the macOS keychain is
  # a different trust store and does not apply to them.
  caBundle = "/etc/ssl/certs/ca-certificates.crt";
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

  # Cisco Secure Access intercepts TLS. The System keychain trusts only the
  # Root CA; the Primary SubCA is an intermediate sent in the handshake, so it
  # does not belong in this bundle. The ZTNA device identity cert is not a CA.
  security.pki.certificateFiles = [
    ../certs/cisco-secure-access-root-ca.crt
  ];

  # NIX_SSL_CERT_FILE is already pointed at caBundle by security.pki. These
  # cover the tools that never look at that variable: OpenSSL's SSL_CERT_FILE,
  # requests, and Node.
  environment.variables = {
    SSL_CERT_FILE = caBundle;
    REQUESTS_CA_BUNDLE = caBundle;
    NODE_EXTRA_CA_CERTS = caBundle;
  };

  # Daemon-side. The launchd plist also sets NIX_SSL_CERT_FILE to caBundle;
  # this keeps fixed-output fetches working if that environment is missing.
  # darwin-rebuild restarts nix-daemon when nix.conf changes.
  nix.settings.ssl-cert-file = caBundle;

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
