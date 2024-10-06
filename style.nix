{ config, pkgs, ... }:
let
  #theme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  wallpaper = ./wallpaper.png;
in {
  stylix = {
    autoEnable = true;
    polarity = "dark";
    opacity.terminal = 0.70;
    homeManagerIntegration.autoImport = true;
    homeManagerIntegration.followSystem = true;
    targets = {
      plymouth.enable = true;
      gtk.enable = true;
      gnome.enable = true;
    };
    image = wallpaper;
    #    base16Scheme = theme;
  };
}

