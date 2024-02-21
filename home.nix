{ config, pkgs, ... }: {
  home.username = "salico";
  home.homeDirectory = "/home/salico";
  home.stateVersion = "23.11"; # Please read the comment before changing.
  home.sessionVariables = {
    EDITOR = "hx";
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
  services.clipman.enable = true;
  gtk = {
    enable = true;
    iconTheme.package = pkgs.papirus-icon-theme;
    iconTheme.name = "Papirus";
  };
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = "*";
  };

  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec = "${pkgs.wezterm}/bin/wezterm";
      exec-arg = "start";
    };
  };
  programs = {
    home-manager.enable = true;
    gh.enable = true;
    btop ={
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
    };
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    wezterm = {
      enable = true;
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
