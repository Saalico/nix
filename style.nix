{ pkgs, ... }:

let
  theme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
  wallpaper = ./wallpaper.png;
in {
  stylix = {
    autoEnable = true;
    polarity = "dark";
    cursor.size = 32;
    opacity.terminal = 0.92;
    homeManagerIntegration.autoImport = true;
    homeManagerIntegration.followSystem = true;
    targets.plymouth = {
      enable = true;
      logo = /etc/nixos/wallpaper.png;
      logoAnimated = false;
    };
    targets.gtk.enable = true;
    image = wallpaper;
    base16Scheme = theme;
    fonts = {
      serif = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };

      sansSerif = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };
    };
  };
}

