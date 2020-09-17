{ pkgs, haskellLib }:
with haskellLib;

(hself: hsuper: {
  # due to ircbridge
  # https://github.com/zohl/cereal-time/pull/2
  cereal-time = markUnbroken (doJailbreak hsuper.cereal-time);

  # due to implicit -> snap, not needed anymore as web stuff is not built by default anymore
  io-streams-haproxy = doJailbreak hsuper.io-streams-haproxy;

  # send PR
  reactive-banana = doJailbreak reactive-banana;
})
