{
  description = "Test Einhorn";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    stylix.url = "github:danth/stylix/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }@inputs:
  let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          nix-flatpak.nixosModules.nix-flatpak
          #inputs.stylix.nixosModules.stylix
          ./configuration.nix
        ];
      };
    };

    homeConfigurations = {
      phoef = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };
    };
  };
}
