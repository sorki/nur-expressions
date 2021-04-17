{ pkgs, haskellLib }:
with haskellLib;

(hself: hsuper: {

  # TODO
  quickspec = markUnbroken (doJailbreak (hsuper.quickspec));

  # TODO pr
  serialport = markUnbroken (doJailbreak (hsuper.serialport));

  # send PR
  reactive-banana = doJailbreak hsuper.reactive-banana;

  # has PRs
  # cryptohash-sha512 = doJailbreak hsuper.cryptohash-sha512;

  # hip w/o diagrams
  hip = enableCabalFlag (dontCheck (hsuper.hip.override({ Chart = null; Chart-diagrams = null; }))) "disable-chart";

})
