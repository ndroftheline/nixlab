{
  description = "Declarative NixOS Home Server Template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs: {
    nixosConfigurations = {
      
      # Target 1: Bare-Metal / VM Server
      "homeserver" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./disko.nix
          ./configuration.nix # Includes hardware, networking, and common.nix
        ];
      };

      # Target 2: WSL Environment
      "wsl" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          ./wsl.nix # Includes WSL-specific settings and common.nix
        ];
      };

    };
  };
}
