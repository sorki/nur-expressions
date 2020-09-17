self: super:
let
  # fix for weird jsaddle flags
  misoSrc = super.fetchFromGitHub {
    owner = "sorki";
    repo = "miso";
    rev = "fb49a83ce21b0aa0734d7087b967b3ab3a833da5";
    sha256 = "1kb80mhw08wpk31r48v8pwl6g6s4vdc2803d6kmfhkwxq278jwd8";
  };
in
{
  ghcjs = super.haskell.packages.ghcjs.override {
    overrides = helf: huper: (huper // (with self.haskell.lib; {
      #mkDerivation = args: huper.mkDerivation (args // { doHaddock = false; });
      mkDerivation = args: huper.mkDerivation (args // { doCheck = false; doHaddock = false; });
      #miso = (disableCabalFlag huper.miso "jsaddle");
      miso = (disableCabalFlag
        ((huper.callCabal2nix "miso" misoSrc { }).overrideAttrs (old: { isExecutable = false; }))
        "jsaddle"
        );

      http-types = dontCheck huper.http-types;
      servant = dontCheck huper.servant;
      comonad = dontCheck huper.comonad;

      # failing
      QuickCheck = dontCheck huper.QuickCheck;
      base-compat-batteries = dontCheck huper.base-compat-batteries;
      Glob = dontCheck huper.Glob;
      scientific = dontCheck huper.scientific;

      # hangs
      monad-par = dontCheck huper.monad-par;
      tasty-quickcheck = dontCheck huper.tasty-quickcheck;
      time-compat= dontCheck huper.time-compat;
      http-media = dontCheck (doJailbreak huper.http-media);
      text-short = dontCheck huper.text-short;
      criterion = dontCheck huper.criterion;
      hourglass = dontCheck huper.hourglass;

      # missing deps when ghcjs
      entropy = huper.entropy.overrideAttrs (old: { buildInputs = old.buildInputs ++ [huper.jsaddle huper.ghcjs-dom ]; });
    }));
  };
}
