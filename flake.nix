{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/23.05";
    home-manager.url = "github:nix-community/home-manager/release-23.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    system = "x86_64-linux";
    username = "tchikmagalore";
    hostname = "developerMachine";
    stateVersion = "23.05";
    lib = inputs.nixpkgs.lib;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "vscode"
        ];
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

    nixosConfigurations = {
      sangraha = lib.nixosSystem {
        inherit system;
        modules = [
          ./machines/sangraha/configuration.nix
        ];
      };
    };
  };

}