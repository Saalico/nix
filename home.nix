{ pkgs, ... }: {
  home.username = "salico";
  home.homeDirectory = "/home/salico";
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "hx";
    TERMINAL = "wezterm";
    SHELL = "nu";
  };

  
  home.packages = [
    (pkgs.writeShellScriptBin "faster" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec "$@"
    '')
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
  };


  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
    systemd.enable = true;
  };
    xdg.configFile."hypr/hyprland.conf".text = ''
    source = ${./hyprland.conf}
  '';

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["gtk" "hyprland"];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  programs = {
    home-manager.enable = true;
    gh.enable = true;
    btop.enable = true;
    eww = {
      enable = true;
      configDir = ./eww;
    };
    swaylock.enable = true;
    wezterm.enable = true;
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
      settings = {
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          auto-pairs = false;
        };
      };
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
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
          }
          $env.EDITOR = 'hx'
        '';
      };
    };

  };
}
