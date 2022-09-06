{ config, pkgs, localPkgs }:

{
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

        localPkgs.dmenu-setxkbmap
        rofimoji
        
        kitty
        xcwd

        gnome3.eog
        evince
        zathura
        xournalpp
        feh

        qgit
        vscode
        meld

        firefox
        chromium

        thunderbird

        gimp
        inkscape
        libreoffice
        vlc
        obs-studio
        scrot

        tdesktop
        hexchat
        discord
      ];
    };
  };
}