{ pkgs, lib, ... }:
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
          version = "unstable-2026-11-10";

          src = pkgs.fetchFromGitHub {
            owner = "automationpi";
            repo = "gh-context";
            rev = "04ca9a85fe39e6d72ddaf3e242b7830ddd8679c9";
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

        agents = {
          query = {
            description = "Read-only query mode - answer questions without editing files";
            mode = "primary";
            system = "You are in read-only query mode. Answer questions, explain code, and propose plans. Do not edit, write, patch, or run mutating shell commands. If changes are needed, describe them as text or a plan for the user to approve.";
            permissions = [
              {
                action = "edit";
                resource = "*";
                effect = "deny";
              }
              {
                action = "shell";
                resource = "*";
                effect = "deny";
              }
              # Read-only shell allowlist (add more as needed)
              {
                action = "shell";
                resource = "ls *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "cat *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "head *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "tail *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "grep *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "rg *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "rg * ./*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "find ./*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "diff *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "wc *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git status*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git log*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git diff*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git show*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git branch*";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git ls-files *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git ls-tree *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git grep *";
                effect = "allow";
              }
              {
                action = "shell";
                resource = "git blame *";
                effect = "allow";
              }
              # Restrict MCP writes (keep reads allowed)
              {
                action = "jira-write_*";
                resource = "*";
                effect = "deny";
              }
              # Subagents - only allow explore for read-only research
              {
                action = "subagent";
                resource = "*";
                effect = "deny";
              }
              {
                action = "subagent";
                resource = "explore";
                effect = "allow";
              }
            ];
          };
        };

        permissions = [
          # Base filesystem
          {
            action = "edit";
            resource = "*";
            effect = "allow";
          }
          {
            action = "read";
            resource = "*";
            effect = "allow";
          }
          {
            action = "grep";
            resource = "*";
            effect = "allow";
          }
          {
            action = "glob";
            resource = "*";
            effect = "allow";
          }
          {
            action = "external_directory";
            resource = "*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "rg *";
            effect = "allow";
          }

          # Sensitive file blacklists (deny even inside project) + .env.example exception
          {
            action = "read";
            resource = "*.env*";
            effect = "deny";
          }
          {
            action = "read";
            resource = "*id_rsa*";
            effect = "deny";
          }
          {
            action = "read";
            resource = "*credentials*";
            effect = "deny";
          }
          {
            action = "read";
            resource = "*.pem";
            effect = "deny";
          }
          {
            action = "edit";
            resource = "*.env*";
            effect = "deny";
          }
          {
            action = "edit";
            resource = "*id_rsa*";
            effect = "deny";
          }
          {
            action = "edit";
            resource = "*credentials*";
            effect = "deny";
          }
          {
            action = "edit";
            resource = "*.pem";
            effect = "deny";
          }
          {
            action = "read";
            resource = "*.env.example";
            effect = "allow";
          }
          {
            action = "edit";
            resource = "*.env.example";
            effect = "allow";
          }

          # Shell baseline + narrow allowlist (no traversal guards; use allowlist instead)
          {
            action = "shell";
            resource = "*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "echo *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "printf *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cat *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "head *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "tail *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "grep *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "rg * ./*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "find ./*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "diff *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "ls *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "wc *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "uname *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "which *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "sort *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "uniq *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cut *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "tr *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "column *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "jq *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "yq *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cat * > *";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "cat * >> *";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "echo * > *";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "echo * >> *";
            effect = "ask";
          }

          # Git & GitHub CLI (read-only)
          {
            action = "shell";
            resource = "git status*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git log*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git diff*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git show*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git ls-files *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git ls-tree *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git cat-file *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git rev-parse*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git rev-list *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git grep *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git blame *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git shortlog *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git describe*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git name-rev *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git merge-base*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git for-each-ref *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git count-objects *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git branch --list *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git branch*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git remote*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git remote -v *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git remote get-url *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git config --get *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git config --list *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "gh pr list*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "gh pr view*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "gh issue list*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "gh issue view*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "git push*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "git commit*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "git reset*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "git checkout*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "git switch*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "git clean*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "git tag*";
            effect = "ask";
          }

          # Go toolchain
          {
            action = "shell";
            resource = "go version*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go env*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go list*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go doc*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go vet*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go test*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go build*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "golangci-lint run*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "go get*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "go mod tidy*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "go install*";
            effect = "ask";
          }

          # Kubernetes (kubectl)
          {
            action = "shell";
            resource = "kubectl version*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl config view*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl config current-context*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl config get-contexts*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl api-resources*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl api-versions*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl get *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl describe *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl diff *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl explain *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl logs *";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "kubectl get secret*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl get secrets*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl exec*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl port-forward*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl apply*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl create*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl edit*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl patch*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl delete*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "kubectl config use-context*";
            effect = "ask";
          }

          # Rust
          {
            action = "shell";
            resource = "cargo --version*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo check*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo clippy*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo test*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo build*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo tree*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo metadata*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "cargo publish*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "cargo install*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "cargo clean*";
            effect = "ask";
          }

          # Node
          {
            action = "shell";
            resource = "npm -v*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "npm list*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "npm test*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "npm run test*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "npm run lint*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "npm run check*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "pnpm test*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "yarn test*";
            effect = "allow";
          }
          {
            action = "shell";
            resource = "npm install*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "npm run build*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "npm publish*";
            effect = "ask";
          }
          {
            action = "shell";
            resource = "npx *";
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
          {
            action = "tool.use";
            resource = "read:../*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "external_directory:*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:sudo *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:rm -rf /*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * main *--force*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * --force* * main *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * master *--force*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * --force* * master *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * develop *--force*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * --force* * develop *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * release/* *--force*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * --force* * release/* *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * release* *--force*";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:git push * --force* * release* *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:kubectl delete namespace *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:kubectl delete all *";
            effect = "deny";
          }
          {
            action = "tool.use";
            resource = "shell:kubectl drain *";
            effect = "deny";
          }
        ];
      };
    };

    mcp = {
      enable = true;
      servers = {
        serena = {
          # Serena — semantic code retrieval/editing via LSP (https://github.com/oraios/serena).
          # Uses uvx to fetch the latest pypi release; uvx caches by version and updates on next fetch.
          # Pin with `serena-agent==2.1.0` if you need reproducibility; otherwise track latest.
          # opencode's enableMcpIntegration merges this into ~/.config/opencode/opencode.json as `mcp.serena`.
          # Context `ide` is the recommended minimal-toolset for IDE/terminal agents (vs. desktop-app/claude-code).
          # --project-from-cwd auto-activates the project from the current working directory (nearest .git/.serena).
          command = "${pkgs.uv}/bin/uvx";
          args = [
            "--from"
            "serena-agent"
            "serena"
            "start-mcp-server"
            "--context"
            "ide"
            "--project-from-cwd"
          ];
        };

        # --- Panacea MCP Gateway (remote) ---
        # All `gw-*` servers share the same gateway API key and base URL pattern.
        # Secrets are injected via `op` (1Password CLI) using `{env:...}` substitution
        # in opencode.json. The env vars below are set to `op://` references in
        # `home.sessionVariables` and `programs.zed-editor.userSettings.agent_servers.OpenCode.env`,
        # and resolved at runtime by `op run -- opencode` (see zed-editor config).
        #
        # 1Password setup (vault `Private`):
        #   Item `Panacea MCP Gateway`:
        #     - `api-key`              → PANACEA_MCP_API_KEY
        #     - `diamond-url`          → GW_DIAMOND_URL
        #     - `panacea-url`          → GW_PANACEA_URL
        #     - `nurag-url`            → GW_NURAG_URL
        #     - `supportgpt-url`       → GW_SUPPORTGPT_URL
        #     - `github-url`           → GW_GITHUB_URL
        #     - `glean-url`            → GW_GLEAN_URL
        #     - `slack-url`            → GW_SLACK_URL
        #     - `atlassian-url`        → JIRA_MCP_URL
        #     - `atlassian-write-url`  → JIRA_WRITE_MCP_URL
        gw-diamond = {
          url = "{env:GW_DIAMOND_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
          };
        };
        gw-panacea = {
          url = "{env:GW_PANACEA_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
          };
        };
        gw-nurag = {
          url = "{env:GW_NURAG_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
          };
        };
        gw-supportgpt = {
          url = "{env:GW_SUPPORTGPT_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
          };
        };
        gw-github = {
          url = "{env:GW_GITHUB_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
          };
        };
        gw-glean = {
          url = "{env:GW_GLEAN_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
          };
        };
        gw-slack = {
          url = "{env:GW_SLACK_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
            "X-Slack-Web-Token" = "{env:SLACK_WEB_TOKEN}";
            "X-Slack-App-Token" = "{env:SLACK_APP_TOKEN}";
          };
        };

        # Jira / Confluence via Panacea gateway — also require Atlassian tokens/URLs.
        # 1Password setup:
        #   Item `Atlassian MCP` (vault `Private`):
        #     - `jira-url`               → ATLASSIAN_JIRA_URL
        #     - `confluence-url`         → ATLASSIAN_CONFLUENCE_URL
        #     - `jira-token`             → ATLASSIAN_JIRA_TOKEN
        #     - `confluence-token`       → ATLASSIAN_CONFLUENCE_TOKEN
        #   Item `Slack MCP` (vault `Private`):
        #     - `web-token`              → SLACK_WEB_TOKEN
        #     - `app-token`              → SLACK_APP_TOKEN
        jira = {
          url = "{env:JIRA_MCP_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
            "X-Atlassian-Jira-Personal-Token" = "{env:ATLASSIAN_JIRA_TOKEN}";
            "X-Atlassian-Jira-Url" = "{env:ATLASSIAN_JIRA_URL}";
            "X-Atlassian-Confluence-Url" = "{env:ATLASSIAN_CONFLUENCE_URL}";
            "X-Atlassian-Confluence-Personal-Token" = "{env:ATLASSIAN_CONFLUENCE_TOKEN}";
          };
        };
        jira-write = {
          url = "{env:JIRA_WRITE_MCP_URL}";
          headers = {
            "x-api-key" = "{env:PANACEA_MCP_API_KEY}";
            "X-Atlassian-Jira-Personal-Token" = "{env:ATLASSIAN_JIRA_TOKEN}";
            "X-Atlassian-Jira-Url" = "{env:ATLASSIAN_JIRA_URL}";
            "X-Atlassian-Confluence-Url" = "{env:ATLASSIAN_CONFLUENCE_URL}";
            "X-Atlassian-Confluence-Personal-Token" = "{env:ATLASSIAN_CONFLUENCE_TOKEN}";
          };
        };

        # Local stdio servers — no secrets in headers; command paths avoid leaking username via PATH lookup.
        xtool = {
          # `xtool` is expected in $HOME/.local/bin (added to PATH via home.sessionPath).
          # Using bare name avoids hard-coding /Users/<user> in the Nix store.
          # TAM account is private — injected via `op` using `{env:...}` substitution.
          # 1Password: `op://Private/xtool/tam-account` → XTOOL_TAM_ACCOUNT
          command = "xtool";
          args = [
            "mcp"
            "serve"
            "--tam-account"
            "{env:XTOOL_TAM_ACCOUNT}"
          ];
        };
        semble = {
          command = "${pkgs.uv}/bin/uvx";
          args = [
            "--from"
            "semble[mcp]"
            "semble"
          ];
        };

        # Localhost dev server — not private, kept literal.
        troubleshoot-live = {
          url = "http://localhost:3000/mcp";
        };
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
      terminal = "screen-256color";

      extraConfig = ''
        bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-selection
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-selection
      '';

      tmuxp.enable = true;
    };

    zed-editor = {
      enable = true;
      userSettings = {
        buffer_font_size = 13;
        ui_font_size = 14;
        terminal.font_size = 13;
        agent_servers = {
          OpenCode = {
            type = "custom";
            command = "op";
            args = ["run" "--" "opencode" "acp"];
            env = {
              NAI_GATEWAY_API_KEY = "op://Private/Nutanix AI Gateway/credential";
              # Panacea MCP Gateway
              PANACEA_MCP_API_KEY = "op://Private/Panacea MCP Gateway/api-key";
              GW_DIAMOND_URL = "op://Private/Panacea MCP Gateway/diamond-url";
              GW_PANACEA_URL = "op://Private/Panacea MCP Gateway/panacea-url";
              GW_NURAG_URL = "op://Private/Panacea MCP Gateway/nurag-url";
              GW_SUPPORTGPT_URL = "op://Private/Panacea MCP Gateway/supportgpt-url";
              GW_GITHUB_URL = "op://Private/Panacea MCP Gateway/github-url";
              GW_GLEAN_URL = "op://Private/Panacea MCP Gateway/glean-url";
              GW_SLACK_URL = "op://Private/Panacea MCP Gateway/slack-url";
              JIRA_MCP_URL = "op://Private/Panacea MCP Gateway/atlassian-url";
              JIRA_WRITE_MCP_URL = "op://Private/Panacea MCP Gateway/atlassian-write-url";
              # Atlassian
              ATLASSIAN_JIRA_URL = "op://Private/Atlassian MCP/jira-url";
              ATLASSIAN_CONFLUENCE_URL = "op://Private/Atlassian MCP/confluence-url";
              ATLASSIAN_JIRA_TOKEN = "op://Private/Atlassian MCP/jira-token";
              ATLASSIAN_CONFLUENCE_TOKEN = "op://Private/Atlassian MCP/confluence-token";
              # Slack
              SLACK_WEB_TOKEN = "op://Private/Slack MCP/web-token";
              SLACK_APP_TOKEN = "op://Private/Slack MCP/app-token";
              # xtool
              XTOOL_TAM_ACCOUNT = "op://Private/xtool/tam-account";
            };
          };
        };
        lsp = {
          nixd = {
            binary = {
              path = lib.getExe pkgs.nixd;
            };
          };
        };
      };
    };

    zoxide = {
      enable = true;
    };
  };

  # 1Password-backed env vars for `op run -- opencode` in the terminal.
  # These are literal `op://` references (not secrets) — resolved at runtime by `op run`.
  # Zed's agent server above handles the same for the editor; this covers CLI usage:
  #   op run -- opencode
  #   op run -- opencode acp
  # Shell alias below makes `opencode` transparently use `op run`.
  home.sessionVariables = {
    NAI_GATEWAY_API_KEY = "op://Private/Nutanix AI Gateway/credential";
    PANACEA_MCP_API_KEY = "op://Private/Panacea MCP Gateway/api-key";
    GW_DIAMOND_URL = "op://Private/Panacea MCP Gateway/diamond-url";
    GW_PANACEA_URL = "op://Private/Panacea MCP Gateway/panacea-url";
    GW_NURAG_URL = "op://Private/Panacea MCP Gateway/nurag-url";
    GW_SUPPORTGPT_URL = "op://Private/Panacea MCP Gateway/supportgpt-url";
    GW_GITHUB_URL = "op://Private/Panacea MCP Gateway/github-url";
    GW_GLEAN_URL = "op://Private/Panacea MCP Gateway/glean-url";
    GW_SLACK_URL = "op://Private/Panacea MCP Gateway/slack-url";
    JIRA_MCP_URL = "op://Private/Panacea MCP Gateway/atlassian-url";
    JIRA_WRITE_MCP_URL = "op://Private/Panacea MCP Gateway/atlassian-write-url";
    ATLASSIAN_JIRA_URL = "op://Private/Atlassian MCP/jira-url";
    ATLASSIAN_CONFLUENCE_URL = "op://Private/Atlassian MCP/confluence-url";
    ATLASSIAN_JIRA_TOKEN = "op://Private/Atlassian MCP/jira-token";
    ATLASSIAN_CONFLUENCE_TOKEN = "op://Private/Atlassian MCP/confluence-token";
    SLACK_WEB_TOKEN = "op://Private/Slack MCP/web-token";
    SLACK_APP_TOKEN = "op://Private/Slack MCP/app-token";
    XTOOL_TAM_ACCOUNT = "op://Private/xtool/tam-account";
  };

  # Transparent `op run` wrapper so plain `opencode` in the terminal still resolves `op://` refs.
  # Users can also run `op run -- opencode ...` explicitly; the alias is a convenience.
  programs.zsh.shellAliases = {
    opencode = "op run -- opencode";
  };
}
