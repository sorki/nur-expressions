self: super:
let
  # https://github.com/vincenthz/hs-git/pull/17
  # https://github.com/vincenthz/hs-git/pull/18
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "hs-git";
    rev = "tmp";
    sha256 = "0ms54x8lbin1sdbfnjywb913y7w9y4824fhxf8zrvii5pyxkamm4";
  };
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { git = hself.callCabal2nix "git" "${src}" { }; });
  });
}
