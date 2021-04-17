{ pkgs, haskellLib }:
with haskellLib;

let
  # until 1.4.0.0 is out
  src = pkgs.fetchFromGitHub {
    owner = "diagrams";
    repo = "diagrams-lib";
    rev = "6f66ce6bd5aed81d8a1330c143ea012724dbac3c";
    sha256 = "0kn3kk8pc7kzwz065g8mpdbsbmbds3vrrgz2215f96ivivv8b9lw";
  };
in
(hself: hsuper: {
  #diagrams-lib = # dontCheck (doJailbreak (
  #  hsuper.callCabal2nix "diagrams-lib" src {}; # ));

  active = markUnbroken ( doJailbreak hsuper.active );
  monoid-extras = markUnbroken ( doJailbreak hsuper.monoid-extras );
  svg-builder = markUnbroken ( doJailbreak hsuper.svg-builder );
  size-based = markUnbroken ( doJailbreak hsuper.size-based );
  force-layout = markUnbroken ( doJailbreak hsuper.force-layout );
  dual-tree = markUnbroken ( doJailbreak hsuper.dual-tree );
  diagrams-core = markUnbroken ( doJailbreak hsuper.diagrams-core );
  diagrams-svg = markUnbroken ( doJailbreak hsuper.diagrams-svg );
  diagrams-lib = markUnbroken ( doJailbreak hsuper.diagrams-lib );
  diagrams-cairo = markUnbroken ( doJailbreak hsuper.diagrams-cairo );
  diagrams-contrib = markUnbroken ( doJailbreak hsuper.diagrams-contrib );
  diagrams-rasterific = markUnbroken ( doJailbreak hsuper.diagrams-rasterific );
  diagrams = markUnbroken ( doJailbreak hsuper.diagrams );
  plots = markUnbroken ( doJailbreak hsuper.plots );
  #diagrams-builder = markUnbroken (doJailbreak (hsuper.diagrams-builder.override { lens = dontCheck (doJailbreak (hself.callHackage "lens" "4.18.1" { template-haskell = doJailbreak (hself.template-haskell_2_16_0_0); })); }));
  diagrams-builder = hsuper.callCabal2nix "diagrams-builder" /home/srk/git/diagrams-builder {};

})
