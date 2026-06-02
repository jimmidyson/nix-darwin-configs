{
  description = "jimmidyson nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
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
  flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    in {
    packages.darwinConfigurations = {
      "V26M4P9FDJ" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = inputs;
        modules = [
          ./nutanix-macbook-pro.nix
        ];
      };
    };

    # Locally packaged tools not (yet) in nixpkgs. Also consumed by
    # home-manager via home-manager/base.nix.
    packages.backport = pkgs.callPackage ./pkgs/backport.nix { };
    packages.troubleshoot-live = pkgs.callPackage ./pkgs/troubleshoot-live.nix { };
  });
}
