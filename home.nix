{ pkgs, inputs, ... }:
let
  OPENAI_API_KEY = import /etc/secrets/OPENAI_API_KEY;
  Wallpaper = /etc/nixos/wallpaper.png;
in {
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
    HYPRLAND_NO_SD_NOTIFY = 1;
    WLR_DRM_NO_ATOMIC = 1;
    __GL_VRR_ALLOWED = 2;
    __GL_GSYNC_ALLOWED = 0;
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    EDITOR = "hx";
    SHELL = "nu";
    TERMINAL = "wezterm";
  };
  fonts.fontconfig.enable = true;
  services = {
    clipman.enable = true;
    mako = {
      enable = true;
      anchor = "top-center";
      borderRadius = 5;

    };
  };
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
  };
  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "${pkgs.wezterm}/bin/wezterm";
      exec-arg = "start";
    };
  };
  stylix = {
    autoEnable = true;
    targets = {
      gtk.enable = true;
      mako.enable = true;
    };
  };
  programs = {
    home-manager.enable = true;
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        color_theme = "stylix";
        theme_background = false;
      };
    };
    firefox = {
      enable = true;
      nativeMessagingHosts = [ pkgs.gnomeExtensions.gsconnect ];
    };
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };
    helix = {
      enable = true;
      defaultEditor = true;
      extraPackages = [ pkgs.marksman ];
      languages.language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt}/bin/nixfmt";
        }
        {
          name = "markdown";
          auto-format = true;
          formatter.command = "${pkgs.marksman}/bin/marksman";
        }
      ];
      settings = {
        editor = {
          line-number = "relative";
          mouse = false;
          shell = [ "nu" "exec" ];
          cursorline = true;
          auto-save = true;
          color-modes = true;
          auto-pairs = false;
          indent-guides = {
            render = true;
            skip-levels = 1;
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          lsp = {
            enable = true;
            auto-signature-help = true;
            display-messages = true;
            display-inlay-hints = true;
            snippets = true;

          };
        };
        keys.normal = {
          space.space = "file_picker";
          space.w = ":w";
          space.q = ":q";
          esc = [ "collapse_selection" "keep_primary_selection" ];
        };
      };
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    wezterm = {
      enable = true;
      extraConfig = ''
        return {
          window_close_confirmation = 'NeverPrompt',
          enable_tab_bar = false
        }
      '';
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
          $env.PATH = ($env.PATH | split row (char esep) | append '/go')
          $env.config = {
            show_banner: false
          }
          $env.EDITOR = hx
          $env.TERM = wezterm
          $env.OPENAI_API_KEY = ${OPENAI_API_KEY}
        '';
      };
    };
    bash = {
      enable = true;
      bashrcExtra = ''
        export XDG_DATA_HOME="$HOME/.local/share"
      '';
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    # change monitor to high resolution, the last argument is the scale factor
    # plugins = [
    #   inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
    #   # ...
    # ];
    settings = {
      # "plugin:touch_gestures" = {
      #   # The default sensitivity is probably too low on tablet screens,
      #   # I recommend turning it up to 4.0
      #   sensitivity = 1.0;

      #   # must be >= 3
      #   workspace_swipe_fingers = 3;

      #   # switching workspaces by swiping from an edge, this is separate from workspace_swipe_fingers
      #   # and can be used at the same time
      #   # possible values: l, r, u, or d
      #   # to disable it set it to anything else
      #   workspace_swipe_edge = "l";

      #   # in milliseconds
      #   long_press_delay = 400;
      #   bind = ",swipe:4:up, killactive";

      #   experimental = {
      #     # send proper cancel events to windows instead of hacky touch_up events,
      #     # NOT recommended as it crashed a few times, once it's stabilized I'll make it the default
      #     send_cancel = 0;
      #   };
      # };
      exec-once =
        [ "hyprlock" "swww init" "swww img ${Wallpaper}" "nwg-panel" ];
      monitor = ",highres,auto,1";
      env = [ "WLR_DRM_DEVICES,/dev/dri/card1:/dev/dri/card0" ];
      decoration = { rounding = 10; };
      input = {
        kb_options = [ "caps:escape_shifted_capslock" ];
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };
      };
      gestures = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
      };

      # unscale XWayland
      xwayland = { force_zero_scaling = true; };

      # toolkit-specific scale
      "$mod" = "SUPER";
      "$shift_mod" = "SUPER_SHIFT";
      bind = [
        # mouse movements

        # Programs
        "$mod, Q, exit"
        "$mod, RETURN, exec, [float; centerwindow] wezterm"
        "$mod, W, exec, firefox"
        "$mod, S, exec, steam"

        #Window Operations
        "$mod, X, killactive"
        "$mod, F, togglefloating"
        "$mod, F, resizeactive, exact 500 500"
        "$mod, F, centerwindow"
        "$shift_mod, SPACE, pin"
        "$shift_mod, F, fullscreen"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"

        "$shift_mod, h, movewindow, l"
        "$shift_mod, j, movewindow, d"
        "$shift_mod, k, movewindow, u"
        "$shift_mod, l, movewindow, r"

        #Move window to Adjascent Workplace
        "$mod, n, movetoworkspace, r+1"
        "$mod, b, movetoworkspace, r-1"
        "$shift_mod, b, movetoworkspacesilent, r-1"
        "$shift_mod, n, movetoworkspacesilent, r+1"

        #Move window to specific workplace

        "$shift_mod, 1, movetoworkspacesilent, 1"
        "$shift_mod, 2, movetoworkspacesilent, 2"
        "$shift_mod, 3, movetoworkspacesilent, 3"
        "$shift_mod, 4, movetoworkspacesilent, 4"
        "$shift_mod, 5, movetoworkspacesilent, 5"
        "$shift_mod, 0, movetoworkspacesilent, 10"

        #Go to specific worplace
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 0, workspace, 10"

        #Window stash
        "$mod, d, exec, nwg-drawer -o eDP-1"
      ];

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
  };
}
