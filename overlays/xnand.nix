self: super:
let
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "xnand";
    rev = "cc186b7d96a4ea2f0fb18cb21f730be5d5776693";
    sha256 = "1y16dx0kbsca57h4ry293x4ykcb010r0rqfhvcra5vavyf5x8x47";
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
