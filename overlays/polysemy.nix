{ pkgs, haskellLib }:
with haskellLib;

let
  # until 1.4.0.0 is out
  src = pkgs.fetchFromGitHub {
    owner = "polysemy-research";
    repo = "polysemy";
    rev = "235813da00cf5ccbfffed82a14eced10ce3faaa7";
    sha256 = "0lyra4xgn31ndg49dzv7cdr5yniby70mqyx57g25wm12k1fs4wip";
  };
in
(hself: hsuper: {
  #co-log-polysemy = markUnbroken (doJailbreak hsuper.co-log-polysemy);
  #polysemy = hsuper.callCabal2nix "polysemy" src {};

  #polysemy-plugin = # dontCheck (doJailbreak (
  #  hsuper.callCabal2nix "polysemy-plugin" (
  #    ''${src}/polysemy-plugin'') {}; # ));

  #polysemy-zoo = doJailbreak hsuper.polysemy-zoo;
})
