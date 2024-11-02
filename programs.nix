{ pkgs, ... }: {
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [

      #Basics
      brave
      chromium
      nushell
      alacritty

      #Comms
      zapzap
      discord
      helix

      opentabletdriver

      #System Management/Exploration
      btop
      nemo
      zoxide
      r2modman

      #Utilities
      asusctl
      mako
      swww
      rofi
      ironbar
      carapace
      overskride
      gamescope
      nil
      gamescope
      hyprpaper
      pomodoro-gtk
      mangohud
      dconf2nix

      #Productivity
      orca-slicer
      dolphin-emu
      bambu-studio
      blender

      #Fun Stuff
      spotify

      #Git n Friends
      gh
      git
    ];
  };
  environment.systemPackages = with pkgs; [
    brightnessctl
    wl-clipboard
    clipman
    lldb
    nixfmt-classic
    go
    udiskie
    xdg-launch
    xdg-terminal-exec
    xdg-utils
    greetd.regreet
  ];
}
