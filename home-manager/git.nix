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
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
          hunk-header-decoration-style = "cyan box ul";
        };
      };
    };

    lfs = {
      enable = true;
    };

    aliases = {
      gone = "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs -t -I{} git branch -D {}";
      aliases = "config --get-regexp '^alias\\.'";
    };

    extraConfig = {
      core = {
        autocrlf = "input";
        editor = "vim";
        # fsmonitor = true;
        # untrackedcache = true;
      };
      # fsmonitor.socketDir = "/Users/jimmi.dyson/.git-fsmonitor-tmp";
      rerere.enabled = true;
      tag = {
        forceSignAnnotated = true;
        sort = "-version:refname";
      };
      remote.origin.fetch = "+refs/pull/*/head:refs/remotes/origin/pr/*";
      init.defaultBranch = "main";
      rebase = {
        autosquash = true;
        updateRefs = true;
      };
      versionsort.suffix = "-";
    };
  };
}
