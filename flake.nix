{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    stylix.url = "github:danth/stylix";
    flake-utils.url = "github:numtide/flake-utils";
    roc.url = "github:roc-lang/roc";
  };

  outputs = { self, nixpkgs, nix-colors, roc, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs { inherit system; };
        rocPkgs = roc.packages.${system};
      in {
        devShells = {
          default = pkgs.mkShell { buildInputs = pkgs: [ rocPkgs.cli ]; };
        };

      }) // inputs.flake-utils.lib.eachDefaultSystemPassThrough (system: {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            ./programs.nix
            ./configuration.nix
            ./style.nix
            inputs.stylix.nixosModules.stylix
            inputs.nix-colors.homeManagerModules.default
            inputs.home-manager.nixosModules.default
            {
              home-manager = {
                extraSpecialArgs = { inherit inputs nix-colors; };
                backupFileExtension = "backupBugged";
                useUserPackages = true;
                users.salico = import ./home.nix;
              };
            }
          ];
        };
      });

}
