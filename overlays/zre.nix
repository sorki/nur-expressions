self: super:
let
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "haskell-zre";
    rev = "3414e003c3664ed27a7c91f71554a95b603ee27c";
    sha256 = "0k5mzpf753aqac88zjyahcv3mpmr8ybzvv72cch02pc6y2s799sn";
  };
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { zre = hself.callCabal2nix "zre" "${src}" { }; });
  });
}
