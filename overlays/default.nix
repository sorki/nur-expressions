let
  # pin these at some point
  hnSrc = "https://github.com/sorki/hnix-overlay/archive/master.tar.gz";
  itnSrc =
    "https://github.com/HaskellEmbedded/ivory-tower-nix/archive/master.tar.gz";
in rec {
  hnix-overlay = import "${builtins.fetchTarball hnSrc}/overlay.nix";
  ivory-tower-nix =
    import "${builtins.fetchTarball itnSrc}/overlay.nix" "ghc883";

  # PRs pending
  ircbot = import ./ircbot.nix;
  hs-git = import ./hs-git.nix;

  zre = import ./zre.nix;
  git-post-receive = import ./git-post-receive-overlay.nix;

  all = [
    ircbot
    hs-git

    git-post-receive
    zre
  ]
  ++ hnix-overlay
  ++ ivory-tower-nix
  ;
}
