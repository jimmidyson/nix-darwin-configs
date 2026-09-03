{
  description = "jimmidyson nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    darwin.url = "github:LnL7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-auth.url = "github:numtide/nix-auth";
    tuicr.url = "github:agavra/tuicr?ref=v0.9.0";
  };

  outputs = inputs@{ self,
                     nixpkgs,
                     darwin,
                     home-manager,
                     flake-utils,
                     nix-auth,
                     tuicr,
                     ... }:
  let
    mkPkgs = system: import nixpkgs {
      inherit system;
      overlays = import ./overlays;
      config.allowUnfree = true;
    };

  in {
    # macOS hosts: managed by nix-darwin, which also drives home-manager as a
    # nix-darwin module (see home-manager/settings.nix).
    #   darwin-rebuild switch --flake .#V26M4P9FDJ
    darwinConfigurations = {
      "V26M4P9FDJ" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = inputs;
        modules = [
          ./nutanix-macbook-pro.nix
        ];
      };
    };

    # Linux hosts: Nix is installed on top of an existing distro, so there is no
    # system-level module to hook into. home-manager runs standalone and only
    # manages the user's profile and dotfiles.
    # The attribute name is "$USER@$(hostname -s)", which home-manager resolves
    # on its own, so `home-manager switch --flake .` is enough on the box. See
    # README.md for the first-run bootstrap.
    homeConfigurations = {
      "jimmi.dyson@jimmi-dyson" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = { inherit tuicr nix-auth nixpkgs; };
        modules = [
          ./nutanix-linux-vm.nix
        ];
      };
    };
  }
  // flake-utils.lib.eachDefaultSystem (system: let
    pkgs = mkPkgs system;

    in {
    # Locally packaged tools not (yet) in nixpkgs. Also consumed by
    # home-manager via home-manager/base.nix.
    packages.backport = pkgs.callPackage ./pkgs/backport.nix { };
    packages.troubleshoot-live = pkgs.callPackage ./pkgs/troubleshoot-live.nix { };
  });
}
