{ pkgs, config, home-manager, lib, ... }:
{
  home.packages = [ pkgs.git-lfs ];

  programs.git = {
    package = pkgs.gitFull;
    enable = true;

    settings = {
      user = {
        name = "Jimmi Dyson";
        email = "jimmidyson@gmail.com";
      };

      alias = {
        gone = "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs -t -I{} git branch -D {}";
        aliases = "config --get-regexp '^alias\\.'";
      };

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

    signing = {
      format = "ssh";
      signByDefault = true;
      signer = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    ignores = [
      "*~"
      "*.swp"
      ".history/"
      ".pythom-version/"
      ".idea/"
    ];

    includes = [
      {
        condition = "hasconfig:remote.*.url:git@github.com:*/**";
        contents = {
          url = {
            "git@personalgit:" = {
              insteadOf = [
                "https://github.com/"
                "git@github.com:"
              ];
            };
          };
          user = {
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNOtzmH4CEiLsg0zU45n7ytZz921zlJlrVWXOW0SV2E";
          };
        };
      }
      {
        condition = "hasconfig:remote.*.url:https://github.com/**/**";
        contents = {
          url = {
            "git@personalgit:" = {
              insteadOf = [
                "https://github.com/"
                "git@github.com:"
              ];
            };
          };
          user = {
            signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNOtzmH4CEiLsg0zU45n7ytZz921zlJlrVWXOW0SV2E";
          };
        };
      }
    ];

    lfs = {
      enable = true;
    };
  };

  programs.delta = {
    enable = true;

    enableGitIntegration = true;

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
}
