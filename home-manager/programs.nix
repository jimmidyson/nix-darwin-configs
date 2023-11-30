{ pkgs, config, home-manager, ... }:
{
  programs = {
    awscli = {
      enable = true;
    };

    bat = {
      enable = true;
    };

    direnv = {
      enable = true;
    };

    eza = {
      enable = true;
    };

    gh = {
      enable = true;
    };

    go = {
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
