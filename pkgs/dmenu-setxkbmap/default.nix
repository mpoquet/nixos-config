{ stdenv, fetchgit
, dmenu
, setxkbmap
, xmodmap
, python3
, which
}:

stdenv.mkDerivation rec {
  pname = "dmenu-setxkbmap";
  version = "0.3.0";

  buildInputs = [
    dmenu
    setxkbmap
    xmodmap
    python3
    which
  ];

  src = fetchgit {
    url = "https://github.com/mpoquet/dmenu-setxkbmap.git";
    rev = "a783d93d391110b74947c078142a5b3cdb544e2d";
    sha256 = "1qffj1gbqzis32f0258srv7pa4ai075apw7pkis6142qh4bkw779";
  };
  patchPhase = ''
    # Patch runtime process dependencies
    sed -iE "sW\"dmenu\"W\"$(which dmenu)\"W" src/dmenu-setxkbmap.py
    sed -iE "sW\"setxkbmap\"W\"$(which setxkbmap)\"W" src/dmenu-setxkbmap.py
    sed -iE "sW\"xmodmap\"W\"$(which xmodmap)\"W" src/dmenu-setxkbmap.py
  '';
  installPhase = "PREFIX=$out make install";
}
