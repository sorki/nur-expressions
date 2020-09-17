# a simple package def to build sc3plugins.nix
{ stdenv
, cmake
, supercollider
, fftw
, libsndfile
, fetchFromGitHub
  }:
let name = "sc3plugins";
in stdenv.mkDerivation rec {

  inherit name;

  # https://github.com/supercollider/sc3-plugins/commit/7d08fab319198f27a5368307d0e9833c41b8053b
  # date = "2020-06-05T09=30=19-07:00";
  src = fetchFromGitHub {
    owner = "supercollider";
    repo = "sc3-plugins";
    rev = "7d08fab319198f27a5368307d0e9833c41b8053b";
    sha256 = "0qxn1dx9ccb5bkxx0mj2nxh5iqvk3xcx23rclqbc3kxv6gn41rwl";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake supercollider fftw libsndfile ];

  cmakeFlags = [
    "-DSUPERNOVA=ON"
    "-DSC_PATH=${supercollider}/include/SuperCollider"
    "-DFFTW3F_LIBRARY=${fftw}/lib/libfftw3.so"
  ];

  enableParallelBuilding = true;

  buildPhase = ''
    cmake .
    cmake --build . --config Release -j32
    cmake --build . --config Release --target install -j32
  '';
}
