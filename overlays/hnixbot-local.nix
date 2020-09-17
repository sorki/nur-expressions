self: super:
let
  src = ~/git/hnixbot;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { hnixbot-local = hself.callCabal2nix "hnixbot" "${src}" { }; });
  });
}
