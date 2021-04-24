self: super:
{
  ghcarm = super.haskell.packages.ghc8102.override {
    overrides = hself: hsuper: (hsuper // (with self.haskell.lib; {
      #mkDerivation = args: hsuper.mkDerivation (args // { doCheck = false; doHaddock = false; });

     aeson = dontCheck hsuper.aeson;
     SHA = dontCheck hsuper.SHA;
    }));
  };
}
