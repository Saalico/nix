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
    name = "rose-pine-cursor";
    gtk.enable = true;
    package = pkgs.rose-pine-cursor;
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
          text-width = 60;
          soft-wrap = {
            enable = true;
            max-wrap = 10;
          };
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
          enable_tab_bar = false,
          front_end = "WebGpu",
          webgpu_power_preference = "LowPower"
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
}
