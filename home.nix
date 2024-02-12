{pkgs, ...
}: { # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "salico";
  home.homeDirectory = "/home/salico";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.sessionVariables = {
    EDITOR = "hx";
    TERMINAL = "blackbox";
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

  programs = {
    home-manager.enable = true;
    starship = {
      enable = true;
      enableNushellIntegration = true;
    };

    helix = { 
      enable = true; 
      defaultEditor = true;
      extraPackages = [pkgs.marksman];
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
