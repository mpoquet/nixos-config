{ config, pkgs, unstablePkgs, localPkgs }:

{
  environment.systemPackages = with pkgs; [
    man-pages fzf
    vim helix
    git tig
    pass ccrypt
    binutils pciutils acpi hwloc dust zenith
    psmisc lsof htop usbutils
    tldr
    termtosvg asciinema
    tree file bat
    unzip unrar jq p7zip
    pdftk poppler-utils
    nmap
    calcurse
    termdown
    wget
    ripgrep fd
  ] ++ [
    localPkgs.cgvg
    localPkgs.persodata-wrappers
  ];
}
