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
      "koekeishiya/formulae"
    ];
    casks = [
      "firefox"
      "font-droid-sans-mono-for-powerline"
      "font-fira-code"
      "font-iosevka-nerd-font"
      "iterm2"
      "tailscale"
    ];
  };
}
