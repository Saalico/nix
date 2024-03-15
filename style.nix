{ config, pkgs, ... }:
let
  theme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
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
      plymouth.enable = true;
      plymouth.blackBackground = true;
      gtk.enable = true;
    };
    image = wallpaper;
    base16Scheme = theme;
  };
}

