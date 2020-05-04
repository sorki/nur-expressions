self: super:
let src = "https://github.com/sorki/git-post-receive/archive/master.tar.gz";
in {
  haskellPackages = super.haskellPackages.override (old: {
    overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (import "${builtins.fetchTarball src}/overlay.nix");
  });
}
