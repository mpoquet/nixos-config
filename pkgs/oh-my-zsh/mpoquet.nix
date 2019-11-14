{ oh-my-zsh, fetchgit }:

oh-my-zsh.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname + "-mpoquet";
  # As I write these lines, nixpkgs's package uses fetchgit.
  # I do the same so the installPhase script works with my modified copy.
  src = fetchgit {
    url = "https://github.com/mpoquet/oh-my-zsh";
    rev = "7f5627e31afc51b0f458db19766877e599efbdca";
    sha256 = "09cpks3vbjqr8z43yv71vchyqa0rrz4v0aikcgnl8an51m0qm66v";
  };
})
