{
  description = "jimmidyson nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    #   darwin-rebuild switch --flake .#H6GQ16XX6K
    darwinConfigurations = {
      "H6GQ16XX6K" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = inputs;
        modules = [
          ./nutanix-macbook-pro.nix
          {
            ids.gids.nixbld = 350;
          }
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

    # Locally packaged tools not (yet) in nixpkgs. Also consumed by
    # home-manager via home-manager/base.nix.
    packages = nixpkgs.lib.genAttrs
      [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ]
      (system: let
        pkgs = mkPkgs system;
      in {
        backport = pkgs.callPackage ./pkgs/backport.nix { };
        troubleshoot-live = pkgs.callPackage ./pkgs/troubleshoot-live.nix { };
      });
  };
}
