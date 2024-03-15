{ pkgs, ... }: {
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #System Base
      bluez
      carapace
      clipman
      dconf
      firefox
      helix
      nushell
      opentabletdriver
      pciutils
      overskride
      wl-clipboard

      #Hyprland
      wayland
      gtk3
      hyprlock
      hypridle
      nwg-panel
      nwg-drawer
      wlr-randr
      mako
      waybar
      swww

      #System Management/Exploration
      btop
      r2modman
      yazi
      zoxide

      #Utilities
      helix-gpt
      marksman

      #Fonts

      #Productivity
      cura
      # orca-slicer
      blender
      drawing

      #Fun Stuff
      spotify
      minecraft

      #Git n Friends
      gh
      git
    ];
  };
  environment.systemPackages = with pkgs; [
    udiskie
    nil
    lldb
    nixfmt
    rustup
    steam
    steam-run
    steamPackages.steam-runtime
  ];
}

