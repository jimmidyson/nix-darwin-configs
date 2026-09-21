{ pkgs, config, ... }:
{
  programs = {
    awscli = {
      enable = true;
      settings = {
        "default" = {
          sso_session = "aws-protoss";
          sso_account_id = "355186487480";
          sso_role_name = "DeveloperAccess";
          region = "us-west-2";
          output = "json";
        };
        "sso-session aws-protoss" = {
          sso_start_url = "https://d-9267030733.awsapps.com/start/#";
          sso_region = "us-west-2";
          sso_registration_scopes = "sso:account:access";
        };
      };
    };

    bat = {
      enable = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      stdlib = ''
        if command -v angrr >/dev/null 2>&1; then
          angrr touch . 2>/dev/null || true
        fi
      '';
    };

    eza = {
      enable = true;
      git = true;
      enableZshIntegration = true;
    };

    gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
      extensions = [
        pkgs.gh-enhance
        pkgs.gh-f

        (pkgs.stdenv.mkDerivation {
          pname = "gh-context";
          version = "latest";

          src = pkgs.fetchFromGitHub {
            owner = "automationpi";
            repo = "gh-context";
            rev = "main";
            hash = "sha256-97srG/x7xkS9/dgf0w+o1TKJk8wdeHCrPe4+1QU9K1M=";
          };

          installPhase = ''
            mkdir -p $out/bin
            cp gh-context $out/bin/
            chmod +x $out/bin/gh-context
          '';
        })
      ];
    };

    gh-dash = {
      enable = true;
    };

    go = {
      enable = true;
    };

    herdr = {
      enable = true;
      settings = {
        keys = {
          command = [
            {
              command = "example.layout.apply";
              description = "apply layout";
              key = "prefix+l";
              type = "plugin_action";
            }
          ];
          prefix = "ctrl+a";
        };
        onboarding = false;
        terminal = {
          default_shell = "zsh";
          new_cwd = "follow";
          shell_mode = "auto";
        };
        theme = {
          auto_switch = true;
          dark_name = "catppuccin";
          light_name = "catppuccin-latte";
          name = "catppuccin";
        };
        ui = {
          agent_panel_sort = "priority";
          sidebar_width = 32;
          sound = {
            enabled = false;
          };
          toast = {
            delivery = "terminal";
          };
        };
      };
    };

    java = {
      enable = true;
    };

    k9s = {
      enable = true;
    };

    mcfly = {
      enable = true;
      keyScheme = "vim";
    };

    starship = {
      enable = true;
      settings = {
        battery = {
          charging_symbol = "⇡ ";
          discharging_symbol = "⇣ ";
          unknown_symbol = "❓ ";
          empty_symbol = "❗ ";
        };
        nodejs.symbol = "[⬢](bold green) ";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      terminal = "screen-screen256";

      extraConfig = ''
        bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-selection
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection
      '';

      tmuxp.enable = true;
    };

    zoxide = {
      enable = true;
    };
  };
}
