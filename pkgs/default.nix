{ pkgs, ... }:

let
  self = rec {
    oh-my-zsh-mpoquet = pkgs.callPackage ./oh-my-zsh/mpoquet.nix { };
    dmenu-setxkbmap = pkgs.callPackage ./dmenu-setxkbmap/default.nix { };
  };
in
  self
