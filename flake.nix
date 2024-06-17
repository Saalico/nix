{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./programs.nix
        ./configuration.nix
        ./style.nix
        inputs.stylix.nixosModules.stylix
        inputs.home-manager.nixosModules.default
        {
          programs.hyprland.enable = true;
          home-manager = {
            extraSpecialArgs = { inherit inputs; };
            backupFileExtension = "bakup";
            useUserPackages = true;
            users.salico = import ./home.nix;
          };
        }
      ];
    };
  };
}

