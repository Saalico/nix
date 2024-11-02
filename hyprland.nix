{ config, pkgs, lib, inputs, ... }:
let
  colorScheme = inputs.nix-colors.colorSchemes.everforest;
  startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
    udiskie
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init &
    sleep 1
    ${pkgs.swww}/bin/swww img ${./img.jpeg} & 
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        " e-DP1, 1920x1200@165, 0x0, auto"
        " HDMI-A-1, 1920x1080@100, -1920x0, auto"
      ];
      xwayland = { force_zero_scaling = true; };
      "$terminal" = "alacritty";
      "$fileManager" = "nemo";
      "$menu" = "rofi -show drun";
      "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
      input = {
        kb_options = "caps:swapescape";
        touchpad = { natural_scroll = true; };
      };
      exec-once = "${startupScript}/bin/start";
      misc = {
        vrr = 2;
        vfr = 0;
      };
      general = lib.mkForce {
        border_size = 5;
        "col.active_border" = "0xff${colorScheme.palette.base08}";
      };
      bind = [
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, W, exec, brave "

        "$mainMod, X, killactive,"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, f, fullscreen,"
        "$mainMod, v, togglefloating,"
        "$mainMod, v, resizeactive, 75% 75%"

        "$mainMod, R, exec, $menu"
        "$mainMod, P, pseudo, # dwindle"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, l, movewindow, r"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, moue_up, workspace, e-1"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"

      ];
      bindl = [

        " ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        " ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        " ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        " ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        " ,XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        " ,XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        " , XF86AudioNext, exec, playerctl next"
        " , XF86AudioPause, exec, playerctl play-pause"
        " , XF86AudioPlay, exec, playerctl play-pause"
        " , XF86AudioPrev, exec, playerctl previous"
      ];

    };
  };
}
