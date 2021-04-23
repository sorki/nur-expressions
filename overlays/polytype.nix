self: super:
let
  # https://github.com/sorki/polytype
  srcX = super.fetchFromGitHub {
    owner = "sorki";
    repo = "polytype";
    rev = "1ee822e5a5bd148c932699c9f5450b3dd1d246d0";
    sha256 = "0bdasya13lc6sdkmdsnbwrisfsbz2aghyp9l253jq7fjr1apr34z";
  };

  src = /home/srk/git/polytype;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { polytype = hself.callCabal2nix "polytype" "${src}" { }; });
  });
}
