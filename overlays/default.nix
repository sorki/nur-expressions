# * haskell overlay collection
let
  syspkgs = import <nixpkgs> {};
  # pin these at some point
  hnSrc = "https://github.com/sorki/hnix-overlay/archive/master.tar.gz";
  itnSrc = "https://github.com/HaskellEmbedded/ivory-tower-nix/archive/master.tar.gz";
in rec {
  hnix-overlay =
    import "${builtins.fetchTarball hnSrc}/overlay.nix";
  ivory-tower-nix =
    import "${builtins.fetchTarball itnSrc}/overlay.nix" "ghc883";

  # PRs pending
  ircbot = import ./ircbot.nix; # done, waiting for release
  hs-git = import ./hs-git.nix;

  # hot
  zre = import ./zre.nix;
  git-post-receive = import ./git-post-receive-overlay.nix;

  # template
  template = (self: super: {
    haskellPackages = super.haskellPackages.override (old: {
      overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (hself: hsuper: {
         template = hsuper.template;
       });
    });
  });

  lib = (self: super: {
    tofu = "0000000000000000000000000000000000000000000000000000";

    ghPR_PoC = url:
      let
        m = builtins.match "(.+)/pull/([0-9]+)" url;
        parts = if m != null then m else throw "Failed to match PR URL";
      in
        builtins.fetchGit {
          url = builtins.elemAt parts 0;
          ref = "refs/pull/${builtins.elemAt parts 1}/head";
        };

    fetchGitHubPR = { url, sha256 ? throw "sha256 required", ...}@x:
      let
        m = builtins.match "https://github.com/(.+)/(.+)/pull/([0-9]+)" url;
        parts = if m != null then m else throw "Failed to match PR URL";
      in
        self.fetchFromGitHub ({
          owner  = builtins.elemAt parts 0;
          repo   = builtins.elemAt parts 1;
          rev    = "refs/pull/${builtins.elemAt parts 2}/head";
        } // (self.lib.filterAttrs (n: v: n != "url") x));

    # > :b pkgs.fetchGitHubCommit {
    # |  url = "https://github.com/liff/hs-git/commit/72951679408cefc68ebec7935d8bb6084f4507c8";
    # |  sha256 = pkgs.tofu; }
    fetchGitHubCommit = { url, sha256 ? throw "sha256 required", ...}@x:
      let
        m = builtins.match "https://github.com/(.+)/(.+)/commit/([a-f0-9]+)" url;
        parts = if m != null then m else throw "Failed to match PR URL";
      in
        self.fetchFromGitHub ({
          owner  = builtins.elemAt parts 0;
          repo   = builtins.elemAt parts 1;
          rev    = builtins.elemAt parts 2;
        } // (self.lib.filterAttrs (n: v: n != "url") x));

     importGitHubPR = fetchArgs: importArgs:
       import (self.fetchGitHubPR fetchArgs) importArgs;

     callCabal2nixOnGitHubPR = fetchArgs: callCabal2nixArgs:
       self.haskellPackages.callCabal2nix "magical" (self.fetchGitHubPR fetchArgs) {};

     haskell = super.haskell // {
       lib = super.haskell.lib // {
         callCabal2nixOnGitHubPR = self.callCabal2nixOnGitHubPR;
       };
    };
    });

  magic = file: (self: super: {
    haskellPackages = super.haskellPackages.override (old: {
      overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (import file {
        pkgs = self;
        haskellLib = super.haskell.lib;
      });
    });
  });

  overlay = file: (self: super: {
    haskellPackages = super.haskellPackages.override (old: {
      overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (import file);
    });
  });

  magic9 = file: (self: super: {
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        ghc901 = super.haskell.packages.ghc901.override (old: {
        overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
          (import file {
            pkgs = self;
            haskellLib = super.haskell.lib;
          });
        });
      };
    };
  });

  magicArm = expr: (self: super: {
    ghcarm = super.ghcarm.override (old: {
      overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (expr {
        pkgs = self;
        haskellLib = super.haskell.lib;
      });
    });
  });

  overlayArm = file: (self: super: {
    ghcarm = super.ghcarm.override (old: {
      overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
      (import file);
    });
  });

  all =
   # hnix-overlay # forces ghc8101 so needs to go first
   # ++
   [
    lib

    # data-stm32

    ircbot
    hs-git

    (overlay "${(syspkgs.callPackage ./src/git-post-receive.nix {})}/overlay.nix")
    (overlay "${(syspkgs.callPackage ./src/ircbridge.nix {})}/overlay.nix")
    zre

    (magic9 ./ghc9.nix)
    (magic ./polysemy.nix)
    (magic ./diagrams.nix)
    (if builtins.pathExists ./wip.nix then magic ./wip.nix else (_: _: {}))

    (import ./polytype.nix)
    (import ./emci.nix)

    # recent prettyprinter and dhall
    # (magic ./prettyprinter.nix)

    # ** web
    (magic ./web.nix)
    (import ./ghcjs-overlay.nix)

    # ** arm
    (import ./ghc-arm-overlay.nix)
    (overlayArm "${(syspkgs.callPackage ./src/ircbridge.nix {})}/overlay.nix")
    (overlayArm "${(syspkgs.callPackage ./src/git-post-receive.nix {})}/overlay.nix")
    # you wish
    # (overlayArm "${(syspkgs.callPackage ./src/hnix-store.nix {})}/overlay.nix")
    (self: super: {
      ghcarm = super.ghcarm.override (old: {
        overrides = super.lib.composeExtensions (old.overrides or (_: _: { }))
        (import
          "${(syspkgs.callPackage ./src/hnix-store.nix {})}/overlay.nix"
          super
          super.haskell.lib);
        });
    })
    (magicArm ({ pkgs, haskellLib }:
      (hself: hsuper:
        {
          emci =
            hsuper.callCabal2nix
              "emci"
              (syspkgs.callPackage ./src/emci.nix {})
              {};
          factoids =
            hsuper.callCabal2nix
              "factoids"
              (syspkgs.callPackage ./src/factoids.nix {})
              {};
          hnix-store-experiments =
            hsuper.callCabal2nix
              "hnix-store-experiments"
              (syspkgs.callPackage ./src/hnix-store-experiments.nix {})
              {};
          ircbot =
            hsuper.callCabal2nix
              "ircbot"
              (syspkgs.callPackage ./src/ircbot.nix {})
              {};
          xnand =
            hsuper.callCabal2nix
              "xnand"
              (syspkgs.callPackage ./src/xnand.nix {})
              {};
        }
      )
    ))

    (magic ./graphics.nix)
    (magic9 ./graphics.nix)

    (magic ./jailbreaks.nix)

    (self: super: {
      sc3plugins = self.callPackage ./sc3plugins.nix {};
      supercollider-sc3 = self.supercollider.overrideAttrs (old: {
        postFixup = ''
          ln -s ${self.sc3plugins}/share/SuperCollider/Extensions/SC3plugins \
            $out/share/SuperCollider/Extensions

          ln -s ${self.sc3plugins}/lib/SuperCollider/plugins \
            $out/share/SuperCollider/Extensions
        '';
        });
      doom-emacs = self.callPackage ./doom-emacs.nix {};
      looking-glass-obs = self.callPackage ./looking-glass-obs.nix {};
      looking-glass-host = self.callPackage ./looking-glass-host.nix {};
      looking-glass-module = self.callPackage ./looking-glass-module.nix {};
    })

    (if builtins.pathExists /home/srk/git/agenix/overlay.nix
     then (import /home/srk/git/agenix/overlay.nix)
     else (_: _: {}))

    (if builtins.pathExists /home/srk/git/xnand
     then (import ./xnand-local.nix)
     else (import ./xnand.nix))
  ]
  ++ ivory-tower-nix
  ;
}
