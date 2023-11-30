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
    bash
    bat
    bind
    coreutils
    curl
    delta
    direnv
    docker
    dos2unix
    eza
    fd
    file
    findutils
    fzf
    gcc
    gh
    github-cli
    gitleaks
    gnumake
    gnupg
    gnused
    go
    gojq
    gomuks
    gopass
    gvproxy
    htop
    inetutils
    jq
    kind
    kubectl
    lefthook
    libarchive
    libvirt
    lima
    mcfly
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
    zip
    zoxide
    zsh
  ];
}
