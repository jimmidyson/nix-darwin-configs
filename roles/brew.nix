{ config, ... }:

{
  #homebrew packages
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    brews = [
      "coreutils"
      "docker-mac-net-connect"
      "pinentry-mac"
      "rtk"
      "skhd"
      "watch"
      "zsh-autosuggestions"
      "zsh-fast-syntax-highlighting"
      "zsh-history-substring-search"
    ];
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
    taps = [
      #"homebrew/cask"
      #"homebrew/core"
      "koekeishiya/formulae"
      "chipmk/tap"
    ];
    casks = [
      "betterdisplay"
      "firefox"
      "font-droid-sans-mono-for-powerline"
      "font-fira-code"
      "font-iosevka-nerd-font"
      "iterm2"
      "notunes"
      "tailscale-app"
    ];
  };
}
