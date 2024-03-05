{ pkgs, ... }: {
  users.users.salico = {
    isNormalUser = true;
    shell = pkgs.nushell;
    description = "salico";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #System Base
      carapace
      chromium
      clipman
      dconf
      firefox
      helix
      nushell
      opentabletdriver
      wayland
      libsecret
      wl-clipboard

      gnome.gnome-terminal
      gnome.gnome-tweaks
      gnomeExtensions.blur-my-shell
      gnomeExtensions.just-perfection
      gnomeExtensions.gsconnect

      #System Management/Exploration
      btop
      r2modman
      yazi
      zoxide
      zellij

      #Utilities
      mods

      #Fonts
      overpass

      #Productivity
      cura
      blender
      drawing

      #Fun Stuff
      spotify
      yuzu-mainline
      yuzu-early-access

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
