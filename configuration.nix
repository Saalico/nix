# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  documentation.nixos.enable = false;
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  time.timeZone = "America/Toronto";
  i18n.defaultLocale = "en_CA.UTF-8";
  networking.hostName = "Bay"; # Define your hostname.
  networking.networkmanager.enable = true;
  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
    };
  };

  # Enable sound with pipewire.
  sound.enable = true;
  security.rtkit.enable = true;

  # Bootloader.
  boot = {
    plymouth = { enable = true; };
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    consoleLogLevel = 0;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    ];
    initrd.verbose = false;
  };
  # Configure keymap in X11
  services = {
    udisks2.enable = true;
    devmon.enable = true;
    gvfs.enable = true;
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
        CPU_MAX_PERF_ON_BAT = 25;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 100; # 80 and above it stops charging
      };
    };
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      displayManager.autoLogin.user = "salico";
      wacom.enable = false;
      displayManager = {
        sddm = {
          enable = true;
          wayland.enable = true;
          settings = {
            Autologin = {
              Session = "hyprland";
              User = "salico";
            };
          };
          autoLogin.relogin = true;
        };
      };
      videoDrivers = [ "nvidia" ];
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
        vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
    pulseaudio.enable = false;
    bluetooth.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
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
  programs = {
    light.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
    steam = {
      enable = true;
      remotePlay.openFirewall =
        true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall =
        true; # Open ports in the firewall for Source Dedicated Server
    };
  };
  environment.sessionVariables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "wezterm";
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

  specialisation = {
    nomad.configuration = {
      system.nixos.tags = [ "nomad" ];
      boot.extraModprobeConfig = ''
        blacklist nouveau
        options nouveau modeset=0
      '';

      services.udev.extraRules = ''
        # Remove NVIDIA USB xHCI Host Controller devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA USB Type-C UCSI devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA Audio devices, if present
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"
        # Remove NVIDIA VGA/3D controller devices
        ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"
      '';
      boot.blacklistedKernelModules =
        [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
    };
  };

  #DON'T CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  system.stateVersion = "23.11"; # Did you read the comment?
  #DON'T CHANGE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
}

