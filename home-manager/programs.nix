{ pkgs, config, home-manager, ... }:
{
  programs = {
    awscli = {
      enable = true;
      credentials = {
        "default" = {
          "credential_process" = "/usr/local/bin/maws li -j";
        };
      };
      settings = {
        "default" = {
          region = "us-west-2";
          output = "json";
        };
      };
    };

    bat = {
      enable = true;
    };

    direnv = {
      enable = true;
    };

    eza = {
      enable = true;
      git = true;
      enableZshIntegration = true;
    };

    gh = {
      enable = true;
      settings = {
        # Workaround for https://github.com/nix-community/home-manager/issues/4744
        version = 1;
      };
    };

    go = {
      enable = true;
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

    zoxide = {
      enable = true;
    };
  };
}
