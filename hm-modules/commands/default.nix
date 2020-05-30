{ pkgs, lib }:

rec {
  home = import ./home.nix;
  nih = import ./nih.nix;
  nixos = import ./nixos.nix;
  nixpkgs = import ./nixpkgs.nix;
  hask = import ./haskell.nix;
  misc = import ./misc.nix;

  #all =  lib.fold (n: a: n // a) {} [ home nih nixos nixpkgs hask ];
  all = {
    example-home = home;

    inherit nih;
    inherit nixos;
    inherit nixpkgs;
    ca = hask;
    inherit hask;
    http.server = "python3 -m http.server";
    ":r" = "cabal build $*";
  };
}
