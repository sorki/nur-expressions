self: super:
let
  # https://github.com/stepcut/ircbot/pull/3
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "ircbot";
    rev = "bc0999b1632265c7aac34e3cee74602e949622a2";
    sha256 = "1h5q3mh0kai98d5g73zl5dn2vi2kzbzxd36m0dk985h615kqcqjl";
  };
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { ircbot = hself.callCabal2nix "ircbot" "${src}" { }; });
  });
}
