{ lib, pkgs, ... }:
let OPENAI_API_KEY = import /etc/secrets/OPENAI_API_KEY;
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
    EDITOR = "hx"; 
    SHELL = "nu";
     TERMINAL = "wezterm";
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
    brave = { enable = true; };
    starship = {
      enable = true;
      enableNushellIntegration = true;
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
          enable_tab_bar = false,
          front_end = "WebGpu",
        }
      '';
    };
    helix = {enable = true;};
     nushell = { enable = true;
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
      text =  ''
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

}
