# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: {
  #MISC
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];
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

  # Enable sound with epeipewire.
  sound.enable = true;
  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };
    # Console

  # Boot
  boot =
  {
    # Plymouth
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
    kernelParams = [ "quiet" "splash" "vga=current" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "nvidia.NVreg_PreserveVideoMemoryAllocations=1"];

    # Boot Loader
    loader =
    {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.editor = false;
    };
  };
  # Bootloader.

  services = {
    power-profiles-daemon.enable = false;
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
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
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

        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 100; # 80 and above it stops charging
      };
    };
  };

  hardware = {
    pulseaudio.enable = false;
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
      powertop
      tlp
      wezterm
      zathura

      #Wayland
      plymouth
      cliphist
      hyprland
      hyprland-protocols
      xdg-desktop-portal-hyprland
      swww

      #config helpers
      gtk4
      gtk3
      gtk2
      gtk-layer-shell
      dconf
      dconf2nix

      #Drawing Stuff
      opentabletdriver
      blender
      drawing

      #AI Stuff
      ollama
      aichat
      nvidia-docker
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
fonts.packages = with pkgs; [
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
];
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "wezterm";
    NIXOS_OZONE_WL = "1";
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}
