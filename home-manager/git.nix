{ pkgs, lib, ... }:
let
  personalKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMNOtzmH4CEiLsg0zU45n7ytZz921zlJlrVWXOW0SV2E";
  workKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPubUu24yDLddpTzZTN4Cg8Z2Bix6khiWrBNtYkUDs3Y";

  mkInclude = condition: hostAlias: signingKey: {
    inherit condition;
    contents = {
      url = {
        "git@${hostAlias}:" = {
          insteadOf = [
            "https://github.com/"
            "git@github.com:"
          ];
        };
      };
      user = { inherit signingKey; };
    };
  };
in {
  home.packages = [ pkgs.git-lfs ];

  programs.git = {
    package = pkgs.gitFull;
    enable = true;

    settings = {
      user = {
        name = "Jimmi Dyson";
        email = "jimmidyson@gmail.com";
        signingKey = personalKey;
      };

      alias = {
        gone = "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '$2 == \"[gone]\" {print $1}' | xargs -t -I{} git branch -D {}";
        aliases = "config --get-regexp '^alias\\.'";
      };

      core = {
        autocrlf = "input";
        editor = "vim";
      };
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
      # macOS signs through the 1Password app's helper binary. On Linux the
      # 1Password agent is reached over a forwarded SSH_AUTH_SOCK, so plain
      # ssh-keygen signing works and home-manager's default signer is right.
      signer = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
        "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
    };

    ignores = [
      "*~"
      "*.swp"
      ".history/"
      ".python-version/"
      ".idea/"
    ];

    includes = [
      (mkInclude "hasconfig:remote.*.url:git@github.com:nutanix-ncn/**" "workgit" workKey)
      (mkInclude "hasconfig:remote.*.url:https://github.com/nutanix-ncn/**" "workgit" workKey)
      (mkInclude "hasconfig:remote.*.url:git@github.com:*/**" "personalgit" personalKey)
      (mkInclude "hasconfig:remote.*.url:https://github.com/**/**" "personalgit" personalKey)
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
