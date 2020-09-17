self: super:
let
  # https://github.com/sorki/emci
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "emci";
    rev = "f565386108a00b2c760cef70eed24129a64aec0a";
    sha256 = "0h9xfb2kc0536rfrvz41xlz0z222jmg3469vqywpsgn3gkgfhd4n";
  };

  srcX = ~/git/emci;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { emci = hself.callCabal2nix "emci" "${src}" { }; });
  });
}
