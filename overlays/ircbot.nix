self: super:
let
  src = super.fetchFromGitHub {
    owner = "stepcut";
    repo = "ircbot";
    rev = "cf2a2a092392d93c1b5db8a74d78bb2a5ff3728d";
    sha256 = "0yzf7da375crvv6fs4npm09bmddx06d4d3g3abh8n98snbqzg2i4";
  };

  # src = super.fetchFromGitHub {
  #   owner = "sorki";
  #   repo = "ircbot";
  #   rev = "d4f9a7521daff6b78b20269d0039fdea49154fb5";
  #   sha256 = "01r8gblwpc7nj6r3la7540jkbr2qdrlnxpas13bp3crkkg3w7rbx";
  # };
  #
  # src = /home/srk/git/ircbot;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { ircbot = hself.callCabal2nix "ircbot" "${src}" { }; });
  });
}
