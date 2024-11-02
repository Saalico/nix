{ config, pkgs, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/everforest.yaml";
  wallpaper = ./wallpaper.jpeg;
in {
  stylix = {
    autoEnable = true;
    polarity = "dark";
    opacity.terminal = 0.9;
    homeManagerIntegration.autoImport = true;
    homeManagerIntegration.followSystem = true;
    targets = {
      plymouth.enable = true;
      gtk.enable = true;
    };
    image = wallpaper;
    base16Scheme = theme;
  };
}

