{ config, ... }:

{
  #homebrew packages
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    brews = [
      "pinentry-mac"
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
      "homebrew/cask"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/core"
      "homebrew/services"
      "amar1729/formulae"
      "colindean/fonts-nonfree"
      "kidonng/malt"
      "aaronraimist/homebrew-tap"
      "koekeishiya/formulae"
    ];
    casks = [
      "blockblock"
      "cursorcerer"
      "firefox"
      "font-droid-sans-mono-for-powerline"
      "font-fira-code"
      "font-iosevka-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-microsoft-office"
      "hammerspoon"
      "hiddenbar"
      "iterm2"
      "knockknock"
      "lulu"
      "oversight"
      "reikey"
      "rustdesk"
      "secretive"
      "shortcat"
      "syncthing"
      "tailscale"
    ];
  };
}
