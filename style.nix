{ config, pkgs, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/rose-pine-moon.yaml";
  wallpaper = ./wallpaper.png;
in {
  stylix = {
    autoEnable = true;
    polarity = "dark";
    cursor.size = 36;
    opacity.terminal = 0.92;
    homeManagerIntegration.autoImport = true;
    homeManagerIntegration.followSystem = true;
    targets = {
      plymouth.logo = ./wallpaper.png;
      plymouth.logoAnimated = false;
      nixvim.enable = true;
      gnome.enable = true;
      gtk.enable = true;
    };
    image = wallpaper;
    base16Scheme = theme;
  };
}

