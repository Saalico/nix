{ pkgs, ... }: {
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #System Base
      gnome.gnome-terminal
      gnome.gnome-tweaks
      gnomeExtensions.gsconnect
      gnomeExtensions.pano
      wayland
      wl-clipboard
      clipman
      nvidia-docker
      dconf
      opentabletdriver
      cura
      helix
      nushell
      firefox
      carapace
      btop
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
}
