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

    opencode = {
      enable = true;
  
      # Optional: Automatically wire any servers defined in `programs.mcp.servers`
      enableMcpIntegration = true;
  
      # Optional: Make extra CLI tools (e.g., ripgrep, fd, jq) available to OpenCode's runtime PATH
      extraPackages = with pkgs; [
        ripgrep
        fd
        jq
      ];
  
      # Global instructions written to ~/.config/opencode/AGENTS.md
      context = ''
        - Prefer concise, idiomatic implementations.
        - Verify changes with LSP diagnostics and local test runners before finalizing.
        - Never add Co-Authored-By, Generated-with, or any attribution trailers/footers to git commits or PR bodies.
      '';

      # Written to ~/.config/opencode/opencode.json ($schema is added automatically)
      settings = {
        model = "nai/ntnx-muse-spark";

        # Disable automatic Co-Authored-By / Generated-with footers in commits/PRs (Zed ACP).
        # Covers upstream sst/opencode, dbirks fork, and oh-my-opencode naming variants.
        includeCoAuthoredBy = false;
        include_co_authored_by = false;
        disable_ai_attribution = true;

        update = "auto";
  
        permissions = [
          {
            action = "edit";
            resource = "*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "*";
            effect = "ask";
          }
          # Allow safe read-only git/nix/search commands without prompting
          {
            action = "shell";
            resource = "git status *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git diff *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "rg *";
            effect = "allow";
          }
          {
            action = "external_directory";
            resource = "*";
            effect = "ask";
          }
        ];
  
        compaction = {
          auto = true;
          buffer = "15%"; # Trigger compaction when 85% of context window is reached
          keep = {
            tokens = 15000; # Retain ~15k tokens of verbatim recent turns alongside the checkpoint summary
          };
        };

        experimental = {
          background_compaction = true;
          subagent_depth = 2;
        };
  
        providers = {
          nai = {
            name = "Nutanix Enterprise AI Gateway";
            package = "@opencode/ai/providers/openai-compatible";
            env = [ "NAI_GATEWAY_API_KEY" ];
            settings = {
              baseURL = "https://tokens.corp.nutanix.com/enterpriseai/gateway/v1/";
              apiKey = "{env:NAI_GATEWAY_API_KEY}";
              headerTimeout = 300000;
            };
            models = {
              "ntnx-beam" = {
                modelID = "ntnx-beam";
                name = "NAI: Beam";
                capabilities = {
                  tools = true;
                  input = [ "text" ];
                  output = [ "text" ];
                };
                limit = {
                  context = 1048576;
                  output = 128000;
                };
              };
              "ntnx-laguna-s-2-1" = {
                modelID = "ntnx-laguna-s-2-1";
                name = "NAI: Laguna S 2.1";
                capabilities = {
                  tools = true;
                  input = [ "text" ];
                  output = [ "text" ];
                };
                limit = {
                  context = 262144;
                  output = 32768;
                };
              };
              "ntnx-muse-glimmer" = {
                modelID = "ntnx-muse-glimmer";
                name = "NAI: Muse Glimmer";
                capabilities = {
                  tools = true;
                  input = [ "text" ];
                  output = [ "text" ];
                };
                limit = {
                  context = 131072;
                  output = 32768;
                };
              };
              "ntnx-muse-spark" = {
                modelID = "ntnx-muse-spark";
                name = "NAI: Muse Spark"; 
                capabilities = {
                  tools = true;
                  input = [ "text" ];
                  output = [ "text" ];
                };
                limit = {
                  context = 1048576;
                  output = 128000;
                };
              };
              "ntnx-nemotron3-super" = {
                modelID = "ntnx-nemotron3-super";
                name = "NAI: Muse Nemotron3 Super"; 
                capabilities = {
                  tools = true;
                  input = [ "text" ];
                  output = [ "text" ];
                };
                limit = {
                  context = 262144;
                  output = 32768;
                };
              };
            };
          };
        };

        policies = [
          {
            action = "provider.use";
            resource = "*";
            effect = "deny";
          }
          {
            action = "provider.use";
            resource = "nai";
            effect = "allow";
          }
        ];
      };
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
  
    zed-editor = {
      enable = true;
      userSettings = {
        agent_servers = {
          OpenCode = {
            type = "custom";
            command = "op";
            args = ["run" "--" "opencode" "acp"];
            env = {
              NAI_GATEWAY_API_KEY = "op://Private/Nutanix AI Gateway/credential";
            };
          };
        };
      };
    };

    zoxide = {
      enable = true;
    };
  };
}
