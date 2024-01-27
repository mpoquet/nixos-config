{ config, pkgs, unstablePkgs, localPkgs }:

{
  environment.systemPackages = with pkgs; [
    man-pages
    vim
    git tig
    pass ccrypt
    binutils pciutils acpi hwloc du-dust
    psmisc lsof htop usbutils
    tldr
    termtosvg asciinema
    tmux
    tree file bat
    unzip unrar jq p7zip
    pdftk poppler_utils
    openconnect openvpn nmap
    calcurse
    termdown
    wget
  ] ++ [
    unstablePkgs.zenith
  ] ++ [
    localPkgs.cgvg
    localPkgs.persodata-wrappers
  ];
}
