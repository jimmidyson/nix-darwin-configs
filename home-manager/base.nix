{ config, pkgs, home-manager, tuicr, lib, ... }:

let
  homeDir = config.home.homeDirectory;
in {
  home.stateVersion = "26.05";
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

  xdg.enable = true;
  xdg.configFile."angrr/config.toml".text = ''
    [temporary-root-policies.direnv]
    path-regex = '/\.direnv/'
    period = '14d'

    [temporary-root-policies.devbox]
    path-regex = '/\.devbox/'
    period = '14d'

    [temporary-root-policies.result]
    path-regex = '/result[^/]*$'
    period = '3d'

    [profile-policies.system]
    profile-paths = [ "/nix/var/nix/profiles/system" ]
    keep-latest-n = 5
  '';

  home.packages = [
    tuicr.defaultPackage.${pkgs.stdenv.hostPlatform.system}
  ] ++ (with pkgs; [
    _1password-cli
    _1password-gui
    amazon-ecr-credential-helper
    angrr
    aws-iam-authenticator
    (callPackage ../pkgs/backport.nix { })
    bash
    bind
    bun
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
    ffmpeg-headless
    file
    findutils
    fnm
    fzf
    fzf-git-sh
    gawk
    gcc
    get_iplayer
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
    headlamp-server
    htop
    inetutils
    kind
    kubectl
    kubectl-ai
    kubectl-convert
    kubectl-df-pv
    kubectl-doctor
    kubectl-evict-pod
    kubectl-explore
    kubectl-gadget
    kubectl-images
    kubectl-klock
    kubectl-ktop
    kubectl-neat
    kubectl-tree
    kubectl-validate
    kubectl-view-allocations
    kubectl-view-secret
    lefthook
    libarchive
    libvirt
    # lima
    nixpkgs-fmt
    nmap
    nodejs
    openssl
    pciutils
    # podman
    prek
    pwgen
    python3
    qemu
    repomix
    ripgrep
    rtk
    srm
    starship
    step-cli
    tcpdump
    time
    tree
    trilium-desktop
    (callPackage ../pkgs/troubleshoot-live.nix { })
    trivy
    unzip
    uv
    vale
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
  ]);
}
