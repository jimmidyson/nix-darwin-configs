{ pkgs, config, home-manager, ... }:
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
