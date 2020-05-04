self: super:
# sed s/PROJECT/.../g
# nix-prefetch-git https://github.com/sorki/PROJECT --rev refs/heads/master
let
  src = super.fetchFromGitHub {
    owner = "sorki";
    repo = "PROJECT";
    rev = "0.1.0.2";
    sha256 = "0d4hndh1yp4402b8klzddbg71cwx2h07v37wa9hzn13236l5mncs";
  };
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: {
        PROJECT = hself.callCabal2nix "PROJECT" "${src}" { };
      });
  });
}
