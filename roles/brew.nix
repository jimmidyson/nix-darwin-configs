{
  homebrew = {
    enable = true;
    enableZshIntegration = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "coreutils"
      "lima"
      "modify-secret"
      "ollama"
      "omp"
      "pinentry-mac"
      "socket_vmnet"
      "watch"
    ];
    extraConfig = ''
      cask_args appdir: "~/Applications"
    '';
    taps = [
      {
        name = "jackielii/tap";
        trusted = true;
      }
      {
        name = "rajatjindal/tap";
        trusted = true;
      }
      {
        name = "anomalyco/tap";
        trusted = true;
      }
      {
        name = "can1357/tap";
        trusted = true;
      }
    ];
    casks = [
      "betterdisplay"
      "font-droid-sans-mono-for-powerline"
      "font-fira-code"
      "font-iosevka-nerd-font"
      "iterm2"
      "notunes"
      "ollama-app"
    ];
  };
}
