# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hw-configuration-laptop-myriads.nix
    ];

  # Allow unfree packages in system configuration
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # /tmp management
  boot.cleanTmpDir = true;
  boot.tmpOnTmpfs = true;

  networking.hostName = "panix"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = false; };
  programs.ssh.startAgent = true;

  networking.firewall.enable = false;

  # Do nothing on lid close
  services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.browsedConf = ''
    BrowsePoll print.irisa.fr:631
  '';

  # Enable GeoClue2 (location service, used by redshift)
  services.geoclue2.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "fr";
    videoDrivers = ["intel"];

    # Touchpad configuration
    libinput = {
      enable = true;
      disableWhileTyping = true;
      tapping = false;
    };

    desktopManager.default = "none";
    desktopManager.xterm.enable = false;
    displayManager = {
      lightdm = {
        enable = true;
      };
    };

    windowManager.default = "i3";
    windowManager.i3.enable = true;
  };

  # Enable sound
  hardware = {
    opengl.enable = true;
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
  };

  # Fonts
  fonts.fonts = with pkgs; [
    emojione
    fira-code
  ];

  # Environment (got from https://github.com/bennofs/etc-nixos)
  environment = {
    pathsToLink = [ "/share" ];
    extraInit = ''
      # these are the defaults, but some applications are buggy so we set them here anyway
      export XDG_CONFIG_HOME=$HOME/.config
      export XDG_DATA_HOME=$HOME/.local/share
      export XDG_CACHE_HOME=$HOME/.cache
    '';

    # QT4/5 global theme
    etc."xdg/Trolltech.conf" = {
      text = ''
        [Qt]
        style=Breeze
      '';
      mode = "444";
    };
  
    # GTK3 global theme (widget and icon theme)
    etc."xdg/gtk-3.0/settings.ini" = {
      text = ''
        [Settings]
        gtk-theme-name=Breeze
        gtk-icon-theme-name=Adwaita
        gtk-font-name=Sans 14
        gtk-cursor-theme-name=Adwaita
        gtk-cursor-theme-size=0
        gtk-toolbar-style=GTK_TOOLBAR_BOTH
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
      '';
      mode = "444";
    };

    # GTK2 global theme (widget and icon theme)
    etc."xdg/.gtkrc-2.0" = {
      text = ''
        gtk-theme-name=Breeze
        gtk-icon-theme-name=Adwaita
        gtk-font-name=Sans 14
        gtk-cursor-theme-name=Adwaita
        gtk-cursor-theme-size=0
        gtk-toolbar-style=GTK_TOOLBAR_BOTH
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=1
        gtk-menu-images=1
        gtk-enable-event-sounds=1
        gtk-enable-input-feedback-sounds=1
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle=hintslight
        gtk-xft-rgba=rgb
      '';
      mode = "444";
    };

    systemPackages = with pkgs; [
      # Tools
      git
      vim
      sublime3
      tree
      wget

      # Graphical survival
      xorg.xrandr
      dmenu
      pass
      sakura
      llpp
      pavucontrol

      # Themes and icons
      breeze-qt5
      breeze-qt4
      gnome3.adwaita-icon-theme
      breeze-icons
      hicolor_icon_theme
    ];
  };

  # Enable zsh
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.carni = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "networkmanager"
      "wheel"
    ];
    shell= pkgs.zsh;
    uid = 1000;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?
}
