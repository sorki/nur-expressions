self: super:
let
  # https://github.com/sorki/emci
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "emci";
    rev = "dc7c97df5b1e479c2b8e9430e9717db0add5f6ff";
    sha256 = "1ays7ndxxbpz4641xq656dqyn2jqwlcin0mqgg3fgfinqf40wp4q";
  };

  srcX = ~/git/emci;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { emci = hself.callCabal2nix "emci" "${src}" { }; });
  });
}
