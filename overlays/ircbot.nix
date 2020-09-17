self: super:
let
  # until 0.6.6+ is released
  src = super.fetchFromGitHub {
    owner = "stepcut";
    repo = "ircbot";
    rev = "e0dee3607ae837b0fc9980e163ed98c25312ca15";
    sha256 = "01zbija3c4nmqv7zv70h1dq9ggsl5jpdfclcxbj53b0f9wn7fl1p";
  };
  srcX = ~/git/ircbot;
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: { ircbot = hself.callCabal2nix "ircbot" "${src}" { }; });
  });
}
