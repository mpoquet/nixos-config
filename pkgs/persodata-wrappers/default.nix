{ rustPlatform, lib, fetchFromGitLab }:

rustPlatform.buildRustPackage rec {
  pname = "persodata-wrappers";
  version = "0.1-0";

  src = fetchFromGitLab {
    domain = "gitlab.com";
    owner = "mpoquet";
    repo = "rust-persodata-wrappers";
    rev = "02f325966d147d4e58e69a98c77da4221dc972b2";
    sha256 = "0px4g5wmw6spgr7yj88xzak1c0qviarxg2a24vfv3xabs6qk145q";
  };

  cargoHash = "sha256-DFLdigARjGAO43HbCva7UG4hRo5P5luIx1Ut6pe+A/k=";
}
