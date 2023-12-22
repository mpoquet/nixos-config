{ config, pkgs, unstablePkgs, localPkgs }:

{
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";

    libinput = {
      enable = true;
      touchpad = {
        scrollMethod = "twofinger";
        tapping = false;
      };
    };

    extraLayouts = {
      bepo-mpoquet = {
        description = "bépo fixed";
        languages = [ "fr" ];
        symbolsFile = ./keyboard-layout/bepo-mpoquet.xkb;
      };
    };

    displayManager.lightdm = {
      enable = true;
      background = pkgs.nixos-artwork.wallpapers.simple-dark-gray-bottom.gnomeFilePath;
      greeters.gtk.extraConfig = ''
        user-background = false
      '';
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock

        xorg.xev

        networkmanagerapplet
        pa_applet

        arandr
        pavucontrol

        pinentry-qt
        browserpass

        localPkgs.dmenu-setxkbmap
        rofimoji kcolorchooser
        kitty
        xcwd xclip

        gnome.eog
        evince mupdf beamerpresenter pdfpc
        zathura
        xournalpp
        feh

        qgit
        vscode
        meld

        lutris
        wine

        firefox
        unstablePkgs.chromium
        thunderbird

        gimp
        inkscape
        libreoffice
        vlc
        obs-studio
        scrot

        tdesktop
        hexchat
        unstablePkgs.mattermost-desktop
        unstablePkgs.discord
        unstablePkgs.signal-desktop
        unstablePkgs.whatsapp-for-linux
      ];
    };
  };

  programs.browserpass.enable = true;
}
