self: super:
let
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "haskell-zre";
    rev = "f11201c1f4122909ed97f787232f28d48aeab225";
    sha256 = "1j9hp88bhh7c44a0cbkmd6w2m077j4a4g7h6f2y8ndkrfymkm3yf";
  };
  srcX = ~/git/haskell-zre;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { zre = hself.callCabal2nix "zre" "${src}" { }; });
  });
}
