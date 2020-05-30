rec {
  c2n = ''
    f=$( echo *.cabal | cut -d'.' -f1 )
    test -f "$f.cabal" || { echo "No .cabal file found"; return 1; }
    cabal2nix . > $f.nix
  '';
  build = "cabal build $*";
  b = build;
  rebuild = "rm -rf dist-newstyle && cabal build $*";
  test = "cabal test $*";
  testall = "cabal test all";
  t = test;
  ta = testall;
  vtest = "cabal test --test-show-details=always $*";
  vt = vtest;
  repl = "cabal repl $*";
  run = "cabal run $*";
}
