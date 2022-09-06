{ stdenv, lib, fetchFromGitHub, perl }:

stdenv.mkDerivation rec {
  pname = "cgvg";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "mpoquet";
    repo = "cgvg";
    rev = "7fef1c9c215b02137fce3b6b4fab526bb1952ece";
    sha256 = "sha256-E2Yt0jWh0US2y6bGNpqPsV8PE3ONsG2fzvGpMTvVy28=";
  };

  buildInputs = [ perl ];

  meta = with lib; {
    description = "Commandline tools for searching and browsing sourcecode";
    longDescription = ''
cgvg is a pair of Perl scripts ("cg" and "vg") which are meant to assist a programmer in doing command-line source browsing.

The idea is you can easily search for keywords in the code, and jump to the file and line where a match is found. Used with ctags(1), this can really help with jumping around and following code. Some features include a human-readable output, coloring, bolding (and alternate bolding), and just sheer convenience for a programmer.

cgvg uses the Perl internal find and does its own searching, rather than being a wrapper for UNIX find(1) and grep(1). There is a ~/.cgvgrc file for per-user configuration, and some nice features like coloring, and multiple log files.
    '';
    homepage = http://uzix.org/cgvg.html;
    license = licenses.gpl2;
    platforms = platforms.all;
    broken = false;
  };
}


