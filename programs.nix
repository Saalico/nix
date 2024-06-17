{ pkgs, ... }: {
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #Comms
      zapzap
      webcord

      #System Base
      carapace
      helix
      brave
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
      mangohud
      dconf2nix
      helix-gpt
      marksman

      #Productivity
      orca-slicer
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
    xdg-launch
    xdg-terminal-exec
    xdg-utils
    rustup
    steam
    steam-run
    steamPackages.steam-runtime
  ];
}

