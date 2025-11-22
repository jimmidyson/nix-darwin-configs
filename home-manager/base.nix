{ config, pkgs, home-manager, lib, ... }:

let
  homeDir = config.home.homeDirectory;
in {
  home.stateVersion = "23.11";
  home.enableNixpkgsReleaseCheck = false;

  nix = {
    package = lib.mkForce pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
    };
    extraOptions = ''
      !include access-tokens.conf
    '';
  };

  home.packages = with pkgs; [
    amazon-ecr-credential-helper
    aws-iam-authenticator
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
    ffmpeg-full
    file
    findutils
    fzf
    gawk
    gcc
    github-copilot-cli
    gitleaks
    gnugrep
    gnumake
    gnupg
    gnutar
    gnused
    gojq
    google-cloud-sdk
    gopass
    granted
    graphviz
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
    time
    tree
    trilium-desktop
    trivy
    unzip
    vale
    yubikey-manager
    zip
    (wrapHelm kubernetes-helm {
      plugins = with kubernetes-helmPlugins; [
        helm-diff
        helm-dt
        helm-git
        helm-mapkubeapis
        helm-schema
        helm-secrets
        helm-s3
      ];
    })
  ];
}
