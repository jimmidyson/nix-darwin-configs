{ config, pkgs, home-manager, ... }:

let
  homeDir = config.home.homeDirectory;
in {
  home.stateVersion = "23.05";
  home.enableNixpkgsReleaseCheck = false;
  nix = {
    package = pkgs.nix;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    bash
    bind
    coreutils
    crane
    curl
    delta
    diceware
    docker
    docker-credential-helpers
    dos2unix
    fd
    file
    findutils
    fzf
    gcc
    gitleaks
    gnumake
    gnupg
    gnused
    gojq
    gomuks
    google-cloud-sdk
    gopass
    gvproxy
    htop
    inetutils
    kind
    kubectl
    lefthook
    libarchive
    libvirt
    lima
    nixpkgs-fmt
    nmap
    openssl
    pciutils
    podman
    pwgen
    python3
    qemu
    ripgrep
    rnix-lsp
    srm
    starship
    tcpdump
    tree
    unzip
    vale
    yubikey-manager
    zip
  ];
}
