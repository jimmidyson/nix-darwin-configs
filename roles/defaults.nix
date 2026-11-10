{ pkgs, nix-auth, ... }:

let
  # nix-darwin concatenates this with the Mozilla bundle. Nix curl's OpenSSL
  # and nix-daemon both read it via NIX_SSL_CERT_FILE; the macOS keychain is
  # a different trust store and does not apply to them.
  caBundle = "/etc/ssl/certs/ca-certificates.crt";
in {
  nixpkgs = {
    config.allowUnfree = true;
    overlays = import ../overlays;
  };

  programs.nix-index.enable = true;

  environment.systemPackages = [
    pkgs.git
    pkgs.kitty
    pkgs.vim
    nix-auth.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

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

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };
  system.defaults = {
    dock.autohide = true;
    finder = {
      AppleShowAllExtensions = true;
      FXEnableExtensionChangeWarning = false;
      CreateDesktop = false;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      ssl-cert-file = caBundle;
    };
    extraOptions = ''
      min-free = ${toString (10 * 1024 * 1024 * 1024)} # 10 GB
      max-free = ${toString (50 * 1024 * 1024 * 1024)} # 50 GB
    '';
    optimise = {
      automatic = true;
      interval = { Hour = 12; Minute = 30; };
    };
    gc = {
      automatic = true;
      interval = { Hour = 3; Minute = 0; };
      options = "--delete-older-than 7d";
    };
  };

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
}
