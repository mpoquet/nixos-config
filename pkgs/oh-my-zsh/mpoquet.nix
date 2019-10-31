{ oh-my-zsh, fetchgit }:

oh-my-zsh.overrideAttrs (oldAttrs: rec {
  pname = oldAttrs.pname + "-mpoquet";
  # As I write these lines, nixpkgs's package uses fetchgit.
  # I do the same so the installPhase script works with my modified copy.
  src = fetchgit {
    url = "https://github.com/mpoquet/oh-my-zsh";
    rev = "4e0be40d8e9bff6f01f4258ab73bb6e5e6ab8003";
    sha256 = "0wma9jcjahqnmidwc4w4ndbxzv2lk7fspmip1rv4k7464z8zidy3";
  };
})
