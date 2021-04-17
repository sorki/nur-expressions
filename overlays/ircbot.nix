self: super:
let
  # until 0.6.6+ is released
  srcU = super.fetchFromGitHub {
    owner = "stepcut";
    repo = "ircbot";
    rev = "e0dee3607ae837b0fc9980e163ed98c25312ca15";
    sha256 = "01zbija3c4nmqv7zv70h1dq9ggsl5jpdfclcxbj53b0f9wn7fl1p";
  };
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "ircbot";
    rev = "d4f9a7521daff6b78b20269d0039fdea49154fb5";
    sha256 = "01r8gblwpc7nj6r3la7540jkbr2qdrlnxpas13bp3crkkg3w7rbx";
  };
  srcX = /home/srk/git/ircbot;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { ircbot = hself.callCabal2nix "ircbot" "${src}" { }; });
  });
}
