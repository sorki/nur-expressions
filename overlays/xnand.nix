self: super:
let
  # FIXME for arm this is using src/xnand.nix, duplicate
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "xnand";
    rev = "11b007568dcd8dfbbb0a7a7151be4441c93c19cb";
    sha256 = "1s5v2p5vb8kx9zx9y8p9igqgghb7jpi1jzxvr9pdxwiy76wfaw2f";
  };
  src-factoids = super.fetchFromGitHub {
    owner = "sorki";
    repo = "factoids";
    rev = "ec144bc6c6a4cf6b9541a36a845e4f4df2158783";
    sha256 = "1p0pd7vyimyzpdlbc4wfrhlk8m91chiapmqhax541p3p52r3dkqy";
  };
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
    (hself: hsuper: {
        factoids = hself.callCabal2nix "factoids" src-factoids { };
        xnand = hself.callCabal2nix "xnand" src { };
    });
  });
}
