{ oh-my-zsh, fetchFromGitHub }:

oh-my-zsh.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname + "-mpoquet";
  src = fetchFromGitHub {
    owner = "mpoquet";
    repo = "oh-my-zsh";
    rev = "8c623a36854db504473d6f51f6d652f9ec34dc8b";
    sha256 = "sha256-rrMbTBgBs/pVlh+0zGcuX1ob9Ji4jFTWUPTafToCuVU=";
  };
})
