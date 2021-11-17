# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  customPackages = pkgs.callPackage ./pkgs/default.nix {};
  pkgs-19-03 = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/20.03.tar.gz";
    sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
  }) {};
  pkgs-unstable = import (fetchTarball http://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) {};
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
    pat = "bat -p";
    ssh = "TERM=xterm-color ssh";
  };
  desired-old-pkgs = with pkgs-19-03; [
    hexchat
  ];
  desired-more-recent-pkgs = with pkgs-unstable; [
    firefox
    chromium
    mattermost-desktop
    signal-desktop
    tdesktop
    cachix
    qtcreator
  ];
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/laptop-datamove2.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_5_15;
  boot.cleanTmpDir = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  networking = {
    hostName = "nyx";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "fr";
  };

  # Fonts
  fonts.fonts = with pkgs; [
    nerdfonts
    liberation_ttf
  ];

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

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.gutenprint ];
    browsedConf = ''
      BrowsePoll print.imag.fr:631
    '';
  };
  services.avahi.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carni = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" "video" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    manpages
    pciutils psmisc bc entr asciinema tldr lsof
    wget vim brightnessctl pass tree gnupg htop file scrot acpi unzip unrar jq bat p7zip
    taskwarrior pdftk poppler_utils
    openconnect sshfs nload nmap
    git
    customPackages.persodata-wrappers
    zsh
    gdb cgdb lldb valgrind customPackages.cgvg
    binutils
    gnome3.networkmanagerapplet gnome3.networkmanager-openconnect pa_applet
    gnome3.adwaita-icon-theme customPackages.dmenu-setxkbmap
    xorg.xev xorg.xkbcomp xvkbd
    kitty xcwd gnome3.eog feh arandr pavucontrol xfce.thunar
    sublime3 clang clang-analyzer meld
    gimp inkscape llpp evince vlc xclip libreoffice
    skype
  ] ++ desired-more-recent-pkgs ++ desired-old-pkgs;

  documentation = {
    dev.enable = true;
    doc.enable = true;
    enable = true;
    info.enable = true;
    man.enable = true;
    nixos.enable = true;
  };

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
  services.openssh.enable = true;

  services.redshift.enable = true;
  location = {
    longitude = 45.1667;
    latitude = 5.7167;
  };

  virtualisation.docker.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
