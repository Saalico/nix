# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, inputs, ... }:

{
  documentation.nixos.enable = false;
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  stylix.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  networking.hostName = "Bay"; # Define your hostname.
  networking.networkmanager.enable = true;
  nixpkgs.config = { allowUnfree = true; };

  # Enable sound with pipewire.
  sound.enable = true;
  security = {
    pam.services.salico.kwallet.enable = true;
    rtkit.enable = true;
  };

  # Bootloader.
  boot = {
    plymouth = { enable = true; };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    kernelParams = [ "quiet" "mem_sleep_default=deep" "udev.log_level=3" ];
    initrd.verbose = false;
  };
  # Configure keymap in X11
  systemd = {
    services.supergfxd.path = [ pkgs.pciutils ];
    sleep.extraConfig = ''
      HibernateDelaySec=30m
      SuspendState=mem
    '';
  };
  services = {
    supergfxd.enable = true;
    desktopManager.plasma6.enable = true;
    desktopManager.plasma6.enableQt5Integration = true;
    asusd = {
      enable = true;
      enableUserService = true;
    };
    power-profiles-daemon.enable = true;
    tlp = {
      enable = false;
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
        STOP_CHARGE_THRESH_BAT0 = 100; # 80 and above it stops charging
      };
    };
    displayManager.autoLogin.user = "salico";
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      displayManager.gdm.enable = true;
      wacom.enable = false;
      videoDrivers = [ "intel" "nvidia" ];
      xkb.layout = "us";
      xkb.variant = "";
    };
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.enable = false;
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      # powerManagement.enable = true;
      # powerManagement.finegrained = true;
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.production;
      prime = {
        offload = {
          # enable = true;
          # enableOffloadCmd = true;
          enable = false;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
    };
    gamemode.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [ mangohud ];

    sessionVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      TERMINAL = "wezterm";
    };
  };

  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # specialisation = {
  #   nomad.configuration = {
  #     system.nixos.tags = [ "nomad" ];
  #     services.tlp.enable = lib.mkForce true;
  #     services.power-profiles-daemon.enable = lib.mkForce false;
  #   };
  # };

  #DON'T CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  system.stateVersion = "23.11"; # Did you read the comment?
  #DON'T CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}

