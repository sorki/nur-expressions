{ pkgs, haskellLib }:
with haskellLib;

let
  src = "";
in
(hself: hsuper: {
  data-lens-light = hsuper.callCabal2nix "data-lens-light" /home/srk/git/data-lens-light {};

  lifted-async = doJailbreak hsuper.lifted-async;
  profunctors = #doJailbreak hsuper.profunctors;
    hsuper.profunctors_5_6_2;
  blaze-markup = doJailbreak hsuper.blaze-markup;
  lens = hsuper.lens_5_0_1;
})
