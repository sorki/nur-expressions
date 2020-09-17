self: super:
let
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "ircbridge";
    rev = "28539440be2d39fdc6a6321fd73561bd574bb890";
    sha256 = "0ryp3nlxx0cl0gif2sda9j3mbb7ffvvvam1qks2kmdfl0r2r2aqd";
  };
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (import "${src}/overlay.nix");
  });
}
