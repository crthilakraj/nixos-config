{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";
    username = "tchikmagalore";
    hostname = "developerMachine";
    stateVersion = "23.05";
    pkgs = import nixpkgs {
      inherit system;
    };
  in rec {
    homeConfigurations = {
      "${username}" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home.username = "${username}";
            home.homeDirectory = "/home/${username}";
            home.stateVersion = "${stateVersion}";
            programs.home-manager.enable = true;
          }
          ./home.nix
        ];
      };
    };
  };
}