{ stdenv
, lib
, fetchFromGitHub
}:
let
  src = fetchFromGitHub {
    owner = "hlissner";
    repo = "doom-emacs";
    rev = "5b3f52f5fb98cc3af653b043d809254cebe04e6a";
    sha256 = "1lsr5gmmfgg5smx2q27qibfmgb0h1vxqla7midxn6l2byalcknkn";
  };
in
stdenv.mkDerivation {
  pname = "doom-emacs";
  version = "git";

  inherit src;

  outputs = [ "out" "bin" ];
  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/doom-emacs
    cp -r $src/* $out/share/doom-emacs
    mkdir -p $bin/bin
    ln -s $src/bin/doom $bin/bin/doom
    ln -s $src/bin/org-tangle $bin/bin/org-tangle
  '';
}
