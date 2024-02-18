{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    eww.url = "github:elkowar/eww";
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, stylix, hyprland, eww, ... }@inputs: {
      homeConfigurations."salico@Bay" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      modules = [
        hyprland.homeManagerModules.default
        {wayland.windowManager.hyprland.enable = true;}
        # ...
      ];
    };

    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        home-manager.nixosModules.home-manager
        stylix.nixosModules.stylix
        {
          home-manager = {
            backupFileExtension = "bakup";
            useUserPackages = true;
            useGlobalPkgs = true;
            users.salico = import ./home.nix;
          };
        }
        ./configuration.nix
        ./style.nix
      ];
    };
  };
}

