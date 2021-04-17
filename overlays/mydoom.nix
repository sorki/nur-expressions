{ pkgs ? import (import ./nixpkgs.nix) {} }:
let

  nix-doom-emacs = pkgs.fetchFromGitHub {
    owner = "vlaci";
    repo = "nix-doom-emacs";
    rev = "7f1a9a4abf4b88256455e17129b5779a7176b4eb";
    sha256 = "1cx9yajwcyl9h0n34gh3qsk8vmz8mfwqagc8wq5vpybqk6nm9724";
  };

  doomConfGit = pkgs.fetchFromGitLab {
    owner = "sorki";
    repo = "doom-emacs-conf";
    rev = "e60261cd730dc4bf2e4f98e6d9bdc82df08b9d9e"; # refs/heads/publish
    sha256 = "0dr2vl2pd5vvfdahq46ki9k8vc25gf23qc9qb812c7zlf1aav727";
  };

  doomConf = pkgs.runCommand "tangled" { }
  ''
    mkdir $out
    cp ${doomConfGit}/* $out
    cd $out
    ${pkgs.emacs}/bin/emacs --batch --eval "(progn (require 'org) (setq org-confirm-babel-evaluate nil) (org-babel-tangle-file \"./config.org\"))"
  '';

in
  pkgs.callPackage nix-doom-emacs {
    doomPrivateDir = doomConf;
  }
