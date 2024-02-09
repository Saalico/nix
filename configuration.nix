# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  # Bootloader.
  boot = {
    plymouth = {
      enable = true;
    };
    loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    initrd.verbose = false;
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;  
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  # Set your time zone.
  time.timeZone = "America/Toronto";

# Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
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

  # Configure keymap in X11
  services = {
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
        CPU_MAX_PERF_ON_BAT = 20;

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };
    xserver = {
      enable = true;
      desktopManager = {
        gnome.enable = true;
        xterm.enable = false;
    };
      displayManager.gdm.enable = true;
      videoDrivers = ["nvidia"];
      xkb.layout = "us";
      xkb.variant = "";
    };
  };


  hardware = { 
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
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
  users.users.salico = {
    isNormalUser = true;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      git
      gh
      nushell
      gnomeExtensions.just-perfection
    ];
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    tlp
    plymouth
    go
    rustup
    gopls
    nil
    rust-analyzer
    nixfmt
  ];

  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
    pkgs.gnome-connections 
    pkgs.gnome-console
    pkgs.gedit       # text editor

    epiphany    # web browser
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    geary       # email client
    # these should be self explanatory
    gnome-maps 
  ];

  home-manager = {
    # also pass inputs to home-manager modules
    extraSpecialArgs = {inherit inputs;};
    users = {
      "salico" = import ./home.nix;
     };
  };  
    
    stylix.autoEnable = true;
     stylix.image = ./wallpaper.png;
     stylix.polarity = "dark";   
     stylix.cursor.size = 36;
     stylix.opacity.terminal = 0.94;

  system.stateVersion = "23.11"; # Did you read the comment?
}
