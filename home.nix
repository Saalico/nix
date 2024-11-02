{ lib, pkgs, config, inputs, ... }:
let colorScheme = inputs.nix-colors.colorSchemes.everforest;
in {
  imports =
    [ inputs.nix-colors.homeManagerModules.default ./hyprland.nix ./helix.nix ];
  home.username = "salico";
  home.homeDirectory = "/home/salico";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.packages = [
    (pkgs.writeShellScriptBin "faster" ''

      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];
  home.sessionVariables = {
    EDITOR = "hx";
    SHELL = "nu";
    TERMINAL = "alacritty";
  };
  fonts.fontconfig.enable = true;
  home.pointerCursor = lib.mkForce {
    gtk.enable = true;
    name = "Nordzy-cursors";
    package = pkgs.nordzy-cursor-theme;
    size = 36;
  };
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
  };
  stylix = {
    enable = true;
    autoEnable = true;
    targets = { gtk.enable = true; };
  };

  programs = {
    home-manager.enable = true;
    gh.enable = true;
    waybar.enable = true;
    btop = {
      enable = true;
      settings = {
        color_theme = "stylix";
        theme_background = false;
      };
    };
    brave = { enable = true; };
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    alacritty = { enable = true; };
    helix = {
      enable = true;

      languages = {
        language-server = { roc-ls = { command = "roc_language_server"; }; };
        language = [
          {
            name = "nix";
            auto-format = true;
            formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
          }
          {
            name = "roc";
            language-servers = [ "roc-ls" ];
            scope = "source.roc";
            injection-regex = "roc";
            file-types = [ "roc" ];
            shebangs = [ "roc" ];
            roots = [ ];
            comment-token = "#";
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            auto-format = true;
            formatter = {
              command = "roc";
              args = [ "format" "--stdin" "--stdout" ];
            };
          }
        ];
        grammar = [{
          name = "roc";
          source = {
            git = "https://github.com/faldor20/tree-sitter-roc.git";
            rev = "master";
          };

        }];
      };
      settings = {
        editor = {
          middle-click-paste = true;
          line-number = "relative";
          auto-format = true;
          auto-completion = true;
        };
      };
    };
    nushell = {
      enable = true;
      configFile = {
        text = ''
          let $config = {
            filesize_metric: false
            table_mode: rounded
            use_ls_colors: true
          }
        '';
      };
      envFile = {
        text = ''
                      $env.config = {
            show_banner: false,
          }        '';

      };
    };

    bash = {
      enable = true;
      bashrcExtra = ''
        export XDG_DATA_HOME="$HOME/.local/share"
      '';
    };
  };

  services = {
    mako = lib.mkForce {
      enable = true;
      backgroundColor = "#${colorScheme.palette.base05}FF";
    };
  };
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   settings = {
  #     monitor = [
  #       " e-DP1, 1920x1200@165, 0x0, auto"
  #       " HDMI-A-1, 1920x1080@100, -1920x0, auto"
  #     ];
  #     xwayland = { force_zero_scaling = true; };
  #     "$terminal" = "alacritty";
  #     "$fileManager" = "nemo";
  #     "$menu" = "rofi -show drun";
  #     "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier
  #     input = { kb_options = "caps:swapescape"; };
  #     exec-once = "${startupScript}/bin/start";
  #     misc = {
  #       vrr = 2;
  #       vfr = 0;
  #     };
  #     input = { natural_scroll = true; };
  #     general = lib.mkForce {
  #       border_size = 5;
  #       "col.active_border" = "0xff${colorScheme.palette.base03}";
  #     };
  #     bind = [
  #       "$mainMod, RETURN, exec, $terminal"
  #       "$mainMod, W, exec, brave "

  #       "$mainMod, X, killactive,"
  #       "$mainMod SHIFT, Q, exit,"
  #       "$mainMod, E, exec, $fileManager"
  #       "$mainMod, V, togglefloating,"
  #       "$mainMod, R, exec, $menu"
  #       "$mainMod, P, pseudo, # dwindle"
  #       "$mainMod, J, togglesplit, # dwindle"
  #       "$mainMod, h, movefocus, l"
  #       "$mainMod, l, movefocus, r"
  #       "$mainMod, k, movefocus, u"
  #       "$mainMod, j, movefocus, d"
  #       "$mainMod SHIFT, h, movewindow, l"
  #       "$mainMod SHIFT, l, movewindow, r"
  #       "$mainMod SHIFT, k, movewindow, u"
  #       "$mainMod SHIFT, j, movewindow, d"
  #       "$mainMod, 2, workspace, 1"
  #       "$mainMod, 1, workspace, 2"
  #       "$mainMod, 3, workspace, 3"
  #       "$mainMod, 4, workspace, 4"
  #       "$mainMod, 5, workspace, 5"
  #       "$mainMod, 6, workspace, 6"
  #       "$mainMod, 7, workspace, 7"
  #       "$mainMod, 8, workspace, 8"
  #       "$mainMod, 9, workspace, 9"
  #       "$mainMod, 0, workspace, 10"
  #       "$mainMod SHIFT, 2, movetoworkspace, 1"
  #       "$mainMod SHIFT, 1, movetoworkspace, 2"
  #       "$mainMod SHIFT, 3, movetoworkspace, 3"
  #       "$mainMod SHIFT, 4, movetoworkspace, 4"
  #       "$mainMod SHIFT, 5, movetoworkspace, 5"
  #       "$mainMod SHIFT, 6, movetoworkspace, 6"
  #       "$mainMod SHIFT, 7, movetoworkspace, 7"
  #       "$mainMod SHIFT, 8, movetoworkspace, 8"
  #       "$mainMod SHIFT, 9, movetoworkspace, 9"
  #       "$mainMod SHIFT, 0, movetoworkspace, 10"
  #       "$mainMod, S, togglespecialworkspace, magic"
  #       "$mainMod SHIFT, S, movetoworkspace, special:magic"
  #       "$mainMod, mouse_down, workspace, e+1"
  #       "$mainMod, mouse_up, workspace, e-1"
  #     ];
  #     bindm = [
  #       "$mainMod, mouse:272, movewindow"
  #       "$mainMod, mouse:273, resizewindow"

  #     ];
  #     bindl = [

  #       " ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
  #       " ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  #       " ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
  #       " ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
  #       " ,XF86MonBrightnessUp, exec, brightnessctl s 10%+"
  #       " ,XF86MonBrightnessDown, exec, brightnessctl s 10%-"
  #       " , XF86AudioNext, exec, playerctl next"
  #       " , XF86AudioPause, exec, playerctl play-pause"
  #       " , XF86AudioPlay, exec, playerctl play-pause"
  #       " , XF86AudioPrev, exec, playerctl previous"
  #     ];

  #   };
  # };
}
