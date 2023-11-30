{ pkgs, config, home-manager, ... }:
{
  home.packages = [ pkgs.git-lfs ];

  programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "Jimmi Dyson";
    userEmail = "jimmidyson@gmail.com";

    ignores = [
      "*~"
      "*.swp"
      ".history/"
      ".pythom-version/"
      ".idea/"
    ];

    signing = {
      key = "E0F45E3A4407632B4BAB0B7F57F2DEC0CF861269";
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {
        features = "decorations";
        navigate = true;
        light = false;
        side-by-side = true;
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
      };
    };

    extraConfig = {
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      rerere.enabled = true;
      tag = {
        forceSignAnnotated = true;
        sort = "-version:refname";
      };
      remote.origin.fetch = "+refs/pull/*/head:refs/remotes/origin/pr/*";
      url."ssh://git@github.com/".insteadOf = "https://github.com/";
      url."ssh://git@gist.github.com/".insteadOf = "https://gist.github.com/";
      init.defaultBranch = "main";
      rebase.autosquash = true;
      versionsort.suffix = "-";
      credential."https://github.com".helper = "!/usr/bin/gh auth git-credential";
      credential."https://gist.github.com".helper = "!/usr/bin/gh auth git-credential";
    };
  };
}
