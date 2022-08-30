{ oh-my-zsh, fetchFromGitHub }:

oh-my-zsh.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname + "-mpoquet";
  src = fetchFromGitHub {
    owner = "mpoquet";
    repo = "oh-my-zsh";
    rev = "481c7de2b375d24857f22c797141d411aa1a435c";
    sha256 = "sha256-nV9KdiDFjqmyUxXHVLJGfCzQD057eSKrLWf/ZLtswwU=";
  };
})
