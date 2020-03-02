# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  customPackages = pkgs.callPackage ./pkgs/default.nix {};
  aliases = {
    cal = "cal --monday";
    disable-screen-saver = "xset -dpms";
    g = "git";
    j = "jump";
    l = "llpp";
    lu = "killall -HUP --regexp '(.*bin/)?llpp'";
    nb = "nix-build";
    ne = "nix-env";
    ns = "nix-shell";
    ssh = "TERM=xterm-color ssh";
  };
in {
  imports =
    [
      ./hardware/laptop-datamove.nix
      ./cachix.nix
    ];

  boot.cleanTmpDir = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_4_14;

  # lid close / suspiend
  services.logind.lidSwitch = "ignore";

  # Network configuration.
  networking = {
    hostName = "ionix"; # Define your hostname.
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "fr";
    defaultLocale = "en_US.UTF-8";
  };

  # Fonts.
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
  ];

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    manpages
    pciutils psmisc bc entr asciinema tldr lsof
    wget vim brightnessctl pass tree gnupg htop file scrot acpi unzip unrar jq bat
    taskwarrior pdftk poppler_utils
    openconnect sshfs nload nmap
    cachix
    git gdb cgdb
    zsh
    binutils
    gnome3.networkmanagerapplet gnome3.networkmanager-openconnect pa_applet
    gnome3.adwaita-icon-theme
    xorg.xev xorg.xkbcomp xvkbd
    kitty xcwd gnome3.eog feh arandr pavucontrol xfce.thunar
    sublime3 qtcreator clang clang-analyzer
    firefox gimp inkscape llpp evince vlc xclip libreoffice
    tdesktop skype hexchat mattermost-desktop
  ];

  documentation = {
    dev.enable = true;
    doc.enable = true;
    enable = true;
    info.enable = true;
    man.enable = true;
    nixos.enable = true;
  };

  hardware.brightnessctl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.zsh = {
    enable = true;
    shellAliases = aliases;
    enableCompletion = true;
    autosuggestions.enable = false;
    ohMyZsh = {
      enable = true;
      plugins = [ "jump" "colored-man-pages" ];
      package = customPackages.oh-my-zsh-mpoquet;
      theme = "mpoquet";
    };
    interactiveShellInit = ''
      export EDITOR=vim
      tabs 4

      function rw () {
        which_result=$(which $1 2>&1)
        which_exit_code=$?
        if [ ''${which_exit_code} -eq 0 ]; then
          echo $(realpath "''${which_result}")
        else
          echo "''${which_result}"
        fi
        return ''${which_exit_code}
      }

      #NIX_BUILD_SHELL=zsh
    '';
    promptInit = "";
  };
  programs.bash = {
    shellAliases = aliases;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.redshift.enable = true;
  location = {
    longitude = 45.1667;
    latitude = 5.7167;
  };

  # Enable docker.
  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    clientConf = ''
      ServerName print.imag.fr:631
    '';
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable OpenGL.
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Graphical configuration.
  services.xserver = {
    enable = true;
    layout = "bepo-mpoquet";

    # custom keyboard layout
    extraLayouts = {
      bepo-mpoquet = {
        description = "bépo fixed";
        languages = [ "fr" ];
        symbolsFile = ./keyboard-layout/bepo-mpoquet.xkb;
      };
    };

    # Enable touchpad support.
    libinput = {
      enable = true;
      scrollMethod = "twofinger";
      tapping = false;
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };

    # Enable the i3 window manager
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
       ];
    };
  };

  # Nix configuration.
  nix.trustedUsers = [ "root" "@wheel" ];

  # Nixpkgs configuration.
  nixpkgs.config.allowUnfree = true;

  # Define a user account.
  users.defaultUserShell = pkgs.zsh;
  users.users.carni = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" "video" ];
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
