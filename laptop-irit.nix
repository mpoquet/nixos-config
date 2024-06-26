# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, unstablePkgs, ... }:

let
  localPkgs = pkgs.callPackage ./pkgs/default.nix {};
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware/laptop-irit.nix

      (import ./shell.nix { inherit config pkgs localPkgs; })
      (import ./headless.nix { inherit config pkgs unstablePkgs localPkgs; })
      (import ./graphical.nix { inherit config pkgs unstablePkgs localPkgs; })
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.tmp.cleanOnBoot = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  services.libinput = {
    enable = true;
    touchpad = {
      scrollMethod = "twofinger";
      tapping = false;
    };
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  networking.hostName = "nyx"; # Define your hostname.

  # Enable networking
  networking.networkmanager = {
    enable = true;
    dispatcherScripts = [
      # Automatically disable/enable wifi when ethernet is plugged in/out
      {
        source = pkgs.writeText "hook" ''
          if [ "$1" != "enp44s0" ]; then
            logger "exit: event $1 != enp44s0"
            exit
          fi

          case "$2" in
            up)
              logger "disabling wifi"
              ${pkgs.networkmanager}/bin/nmcli radio wifi off
              ;;

            down)
              logger "enabling wifi"
              ${pkgs.networkmanager}/bin/nmcli radio wifi on
              ;;

            *)
              logger "exit: $2 neither 'up' nor 'down'"
              exit
              ;;
          esac
        '';
        type = "basic";
      }
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.utf8";
    LC_IDENTIFICATION = "fr_FR.utf8";
    LC_MEASUREMENT = "fr_FR.utf8";
    LC_MONETARY = "fr_FR.utf8";
    LC_NAME = "fr_FR.utf8";
    LC_NUMERIC = "fr_FR.utf8";
    LC_PAPER = "fr_FR.utf8";
    LC_TELEPHONE = "fr_FR.utf8";
    LC_TIME = "fr_FR.utf8";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound and make pulseaudio sinks/sources readable
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraConfig = ''
    update-sink-proplist alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_3__sink device.description='HDMI 1'
    update-sink-proplist alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_4__sink device.description='HDMI 2'
    update-sink-proplist alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_5__sink device.description='HDMI 3'
    update-sink-proplist alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__sink device.description='Speaker + Headphones'
    update-source-proplist alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp_6__source device.description='Laptop microphone'
    update-source-proplist alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi__hw_sofhdadsp__source device.description='Headset microphone'
  '';

  services.logind = {
    lidSwitch = "ignore";
    extraConfig = ''
      HandlePowerKey=ignore
    '';
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  virtualisation.virtualbox.host.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.carni = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "carni";
    extraGroups = [ "networkmanager" "audio" "video" "wheel" "docker" ];
  };
  users.extraGroups.vboxusers.members = [ "carni" ];

  fonts.packages = with pkgs; [
    fira
    fira-code
    inconsolata
  ];

  nix.package = unstablePkgs.nix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.redshift.enable = true;
  location = {
    longitude = 43.6046;
    latitude = 1.4442;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
