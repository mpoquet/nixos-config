{ pkgs, ... }:

let
  self = rec {
    oh-my-zsh-mpoquet = pkgs.callPackage ./oh-my-zsh/mpoquet.nix { };
  };
in
  self
