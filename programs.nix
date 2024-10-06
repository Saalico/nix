{ pkgs, ... }: {
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #Comms
      teams-for-linux
      zapzap
      discord
      helix

      #System Base
      brave
      chromium
      carapace
      nushell
      gamescope
      asusctl
      supergfxctl
      opentabletdriver

      #System Management/Exploration
      btop
      zoxide
      r2modman

      #Utilities
      gamescope
      pomodoro-gtk
      mangohud
      dconf2nix

      #Productivity
      orca-slicer
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
    nil
    lldb
    nixfmt
    go
    xdg-launch
    xdg-terminal-exec
    xdg-utils
    steam
    steam-run
    steamPackages.steam-runtime
  ];
}
