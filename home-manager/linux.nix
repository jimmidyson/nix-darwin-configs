{ config, pkgs, lib, ... }:

let
  # Rocky's system trust store, as maintained by `update-ca-trust`. This is
  # where the corporate root CA lands, so point Nix-built tools at it — the
  # same job roles/defaults.nix does on the darwin hosts.
  caBundle = "/etc/pki/tls/certs/ca-bundle.crt";
in {
  imports = [
    ./base.nix
  ];

  # Nix on a non-NixOS distro: sources the daemon's profile.d/nix.sh, adds the
  # distro's zsh completions to fpath, and fixes TERMINFO_DIRS/XDG_DATA_DIRS so
  # Nix-built and dnf-installed programs can see each other.
  targets.genericLinux.enable = true;

  # Standalone home-manager has to install its own CLI; on darwin the
  # nix-darwin module drives activation instead.
  programs.home-manager.enable = true;

  # `nix-locate` / command-not-found handler. On darwin this comes from the
  # nix-darwin module in roles/defaults.nix, which standalone home-manager
  # never evaluates.
  programs.nix-index.enable = true;

  home.sessionVariables = {
    NIX_SSL_CERT_FILE = caBundle;
    SSL_CERT_FILE = caBundle;
    REQUESTS_CA_BUNDLE = caBundle;
    NODE_EXTRA_CA_CERTS = caBundle;
  };

  home.packages = with pkgs; [
    # On darwin these come from roles/defaults.nix's environment.systemPackages,
    # which is a nix-darwin module that standalone home-manager never evaluates.
    # zsh.nix exports EDITOR=vim and git.nix sets core.editor, so vim is not
    # optional here.
    vim

    # Headless box: no GUI pinentry, so gpg/gopass prompt in the terminal.
    pinentry-tty

    # Rocky 8 ships these, but at RHEL 8 vintage.
    docker-client
    iproute2
    lsof
    psmisc
    util-linux
  ];
}
