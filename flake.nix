{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    stylix.url = "github:danth/stylix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        ./style.nix
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        {
          home-manager = {
            backupFileExtension = "bakup";
            useUserPackages = true;
            users.salico = import ./home.nix;
          };
        }
      ];
    };
  };
}

