# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  nixpkgs.overlays = [
  (final: prev: {
    gnome = prev.gnome.overrideScope' (gnomeFinal: gnomePrev: {
      mutter = gnomePrev.mutter.overrideAttrs ( old: {
        src = pkgs.fetchgit {
          url = "https://gitlab.gnome.org/vanvugt/mutter.git";
          # GNOME 45: triple-buffering-v4-45
          rev = "0b896518b2028d9c4d6ea44806d093fd33793689";
          sha256 = "sha256-mzNy5GPlB2qkI2KEAErJQzO//uo8yO0kPQUwvGDwR4w=";
        };
      } );
    });
  })
];
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
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
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Bootloader.
  boot = {
    plymouth = { enable = true; };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    initrd.verbose = false;
  };

  # Configure keymap in X11
  services = {
    xserver.excludePackages = [ pkgs.xterm ];
    power-profiles-daemon.enable = false;
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
        CPU_MAX_PERF_ON_BAT = 35;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 100; # 80 and above it stops charging
      };
    };
    xserver = {
      enable = true;
      desktopManager = {
        gnome.enable = true;
      };
      displayManager.gdm.enable = true;
      videoDrivers = [ "nvidia" ];
      xkb.layout = "us";
      xkb.variant = "";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.dconf.enable = true;
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #System Base
#      gnome.gnome-terminal
      gnome.gnome-tweaks
      gnomeExtensions.gsconnect
      nvidia-docker
      nautilus-open-any-terminal
      dconf
      opentabletdriver
      helix
      nushell
      firefox
      carapace
      btop
      wezterm
      blender
      drawing  

      #Fonts
      overpass
  
      #Productivity
      ollama
      aichat

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


  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
    pkgs.gnome-connections
    pkgs.gnome-console
    pkgs.gedit # text editor

    epiphany # web browser
    simple-scan # document scanner
    yelp # help viewer
    geary # email client
    # these should be self explanatory
    gnome-maps
    gnome-system-monitor
  ];
  services.gnome.gnome-settings-daemon.enable = true;

  environment.variables = {
     EDITOR = "hx";
     VISUAL = "hx";
     TERMINAL = "wezterm";
   };

  system.stateVersion = "23.11"; # Did you read the comment?
}
