{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    vscode-server.url = "github:nix-community/nixos-vscode-server";
    sopd-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, vscode-server, vscode-extensions, ... }@inputs: let
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
      overlays = [vscode-extensions.overlays.default];
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
          vscode-server.nixosModules.default
          inputs.sops-nix.nixosModules.sops
        ];
      };
    };
  };

}