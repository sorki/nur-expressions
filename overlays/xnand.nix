self: super:
let
  src = super.callPackage ./src/xnand.nix {};
  src-factoids = super.callPackage ./src/factoids.nix {};
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
    (hself: hsuper: {
        factoids = hself.callCabal2nix "factoids" src-factoids { };
        xnand = hself.callCabal2nix "xnand" src { };
    });
  });
}
