{ oh-my-zsh, fetchFromGitHub }:

oh-my-zsh.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname + "-mpoquet";
  src = fetchFromGitHub {
    owner = "mpoquet";
    repo = "oh-my-zsh";
    rev = "dcad6c8d4a3ba0e201768a6179b3179444744a33";
    sha256 = "sha256-/8v9ccTTyGHywv+4BEk30Z+1Xe1NGEnNiZfH7YcHb/Y=";
  };
})
