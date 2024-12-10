{ config, pkgs, home-manager, ... }:

let
  homeDir = config.home.homeDirectory;
in {
  home.stateVersion = "23.11";
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
    cacert
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
    gawk
    gcc
    gitleaks
    gnugrep
    gnumake
    gnupg
    gnutar
    gnused
    gojq
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
    nodejs
    openssl
    pciutils
    # podman
    pwgen
    python3
    qemu
    ripgrep
    srm
    starship
    step-cli
    tcpdump
    tree
    unzip
    vale
    yubikey-manager
    zip
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })
  ];
}
