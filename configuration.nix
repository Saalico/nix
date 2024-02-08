# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Configure keymap in X11
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.salico = {
    isNormalUser = true;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
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


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    firefox
    git
    gh
    helix
    wezterm
    nushell
    gnome.gnome-tweaks
  ];

  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-tour
    pkgs.gedit       # text editor
    pkgs.gnome-connections 
    pkgs.gnome-console

    epiphany    # web browser
    simple-scan # document scanner
    totem       # video player
    yelp        # help viewer
    geary       # email client
    # these should be self explanatory
    gnome-maps 
  ];
  system.stateVersion = "23.11"; # Did you read the comment?
}
