# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/laptop-datamove.nix
    ];

  boot.cleanTmpDir = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_4_14;

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

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    pciutils
    wget vim brightnessctl pass tree gnupg htop file
    git
    zsh oh-my-zsh
    gnome3.networkmanagerapplet pa_applet gnome3.adwaita-icon-theme
    sakura xcwd gnome3.eog feh arandr
    sublime3 qtcreator clang clang-analyzer
    firefox gimp inkscape llpp
  ];

  hardware.brightnessctl.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.zsh = {
    enable = true;
    shellAliases = {
      l = "llpp";
      lu = "killall -HUP --regexp '(.*bin/)?llpp'";
    };
    enableCompletion = true;
    autosuggestions.enable = true;
    interactiveShellInit = ''
      export EDITOR=vim
      export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh
      export ZSH_THEME="muse"
      if [ "$(whoami)" = "root" ]; then
        export ZSH_THEME="darkblood"
      fi
      plugins=(git)
      source $ZSH/oh-my-zsh.sh
    '';
    promptInit = "";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.redshift = {enable = true; longitude = "-1.6777926"; latitude = "48.117266"; };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    layout = "fr";
    xkbOptions = "eurosign:e";

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
    extraGroups = [ "wheel" "audio" "video" ]; # Enable ‘sudo’ for the user.
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?
}
