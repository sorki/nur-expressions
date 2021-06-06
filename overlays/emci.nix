self: super:
let
  # https://github.com/sorki/emci
  src = super.callPackage ./src/emci.nix {};

  srcX = ~/git/emci;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { emci = hself.callCabal2nix "emci" "${src}" { }; });
  });
}
