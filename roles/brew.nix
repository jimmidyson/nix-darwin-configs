{ config, ... }:

{
  #homebrew packages
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    onActivation.cleanup = "zap";
    brews = [
      "coreutils"
      #"docker-mac-net-connect"
      "lima"
      "modify-secret"
      "moltis"
      "pinentry-mac"
      "socket_vmnet"
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
      {
        name = "jackielii/tap";
        trusted = true;
      }
      {
        name = "moltis-org/tap";
        trusted = true;
      }
      {
        name = "rajatjindal/tap";
        trusted = true;
      }
      # "chipmk/tap"
    ];
    casks = [
      "betterdisplay"
      "firefox"
      "font-droid-sans-mono-for-powerline"
      "font-fira-code"
      "font-iosevka-nerd-font"
      "iterm2"
      "notunes"
      "skhd-zig"
      "tailscale-app"
    ];
  };
}
