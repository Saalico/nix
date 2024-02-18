# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Select internationalisation properties.
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  networking.hostName = "Bay"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security = {
    polkit.enable = true;
    rtkit.enable = true;
    pam.services.swaylock = {}; 
  };

  # Bootloader.
  boot = {
    kernelParams = [ "quiet" "udev.log_level=3" "nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    plymouth.enable = true;
    initrd.verbose = false;
  };

  services = {
    xserver.excludePackages = [ pkgs.xterm ];
    getty.autologinUser = "salico";
    power-profiles-daemon.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
   greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "salico";
      };
        default_session = initial_session;
    };
    };    
    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 40;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 100; # 80 and above it stops charging
      };
    };
  };

  hardware = {
    opentabletdriver = {
      enable = true;
      daemon.enable = true;

    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      powerManagement.enable = true;
      powerManagement.finegrained = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

      #System Base
      btop
      carapace
      firefox
      helix
      nushell
      plymouth
      powertop
      tlp
      systemd
      wezterm
      zathura

      #Wayland
      wayland
      cliphist
      hyprland
      hyprland-protocols
      xdg-desktop-portal-hyprland
      waybar
      hyprnome
      swww
      eww
      eww-wayland
      pamixer
      brightnessctl


      #config helpers
      gtk4
      gtk3
      gtk2
      gtk-layer-shell
      swaylock
      polkit_gnome
      dconf
      nautilus-open-any-terminal
      dconf2nix

      #Drawing Stuff
      opentabletdriver
      blender
      drawing

      #AI Stuff
      ollama
      aichat
      nvidia-docker

      #Fonts
        cantarell-fonts      
  overpass
  liberation_ttf
  nerdfonts
  fira-code
  fira-code-symbols
  font-awesome
  font-awesome_4
  font-awesome_5
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts



      #Fun Stuff
      spotify

      #Toolchains
      go
      rustup
      gopls
      rustup
      rust-analyzer
      nil
      nixfmt

      #Git n Friends
      gh
      git

    ];
  };
  system.fsPackages = [ pkgs.bindfs ];
  fileSystems = let
    mkRoSymBind = path: {
      device = path;
      fsType = "fuse.bindfs";
      options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
    };
    aggregatedIcons = pkgs.buildEnv {
      name = "system-icons";
      paths = with pkgs; [
        #libsForQt5.breeze-qt5  # for plasma
        gnome.gnome-themes-extra
      ];
      pathsToLink = [ "/share/icons" ];
    };
    aggregatedFonts = pkgs.buildEnv {
      name = "system-fonts";
      paths = config.fonts.packages;
      pathsToLink = [ "/share/fonts" ];
    };
  in {
    "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
    "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
  };

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "wezterm";
    NIXOS_OZONE_WL = "1";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };
  system.stateVersion = "23.11"; # Did you read the comment?
}
