{ pkgs, haskellLib }:
with haskellLib;

(hself: hsuper: {
  servant = dontCheck (doJailbreak hsuper.servant);
  servant-server = doJailbreak hsuper.servant-server;
  http-media = doJailbreak hsuper.http-media;
})
