{ pkgs, ... }:

let
  theme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  wallpaper = ./wallpaper.png;
in {
  stylix = {
    autoEnable = true;
    polarity = "dark";
    cursor.size = 36;
    opacity.terminal = 0.95;
    homeManagerIntegration.autoImport = true;
    homeManagerIntegration.followSystem = true;
    targets.plymouth.logo = ./cat.png;
    targets.plymouth.logoAnimated = false;
    targets.gnome.enable = true;
    targets.gtk.enable = true;
    image = wallpaper;
    base16Scheme = theme;
  };
}

