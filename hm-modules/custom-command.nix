{ config, lib, pkgs, ... }:

let

  cfg = config.home.cmd;

  toAttrs = xs: lib.listToAttrs (builtins.map
    (x: lib.nameValuePair x.commandPath x.commandScript) xs);

  mkCmd = path: value:
    {
      commandPath = path;
      commandScript = value;
    };

  # let cmd = { my = rec { sub = "test"; s = sub; }; }
  # in toBinaries
  # > { "bin/my-sub": "test"; "bin/my-s": "test"; }
  # ^^ outdated already :x
  binaries = toAttrs (
    lib.collect (builtins.hasAttr "commandScript")
      (lib.mapAttrsRecursive (path: value:
        mkCmd "bin/${lib.concatStringsSep "_" path}" value
      ) cfg)
      ++ topLevel cfg
      );

  # internally we separate sub commands by _
  # external could be configurable
  # but for now we use bashes builtin functionality
  # parseArgs ..

  wrapperScript = named: mkCmd "bin/${named}"
    ''
    #!${pkgs.bash}/bin/bash

    # convert "example sub sub2 --args" to "example_sub_sub" lookups

    args=("$@")
    selector="$( for arg in "''${args[@]}"; do
      # XXX: this previosly stopped when encountered '-' prefix
      # if [[ ''${arg:0:1} == "-" ]] ; then break; fi
      echo -n "_$arg"
    done )"

    listAll() {
      echo "Available sub commands: "
      find ~/bin/ -name '${named}_*' -exec basename {} \;
    }

    if [ "''${selector}" == "" ]; then
      echo "Command not specified"
      listAll
      exit 1
    fi

    echo "Looking for ''${selector}"
    if type "${named}''${selector}" &> /dev/null; then
      # exact
      exec "${named}''${selector}"
    else
      next="''${selector}"
      stripped=""
      while true; do
        # except last _part
        stripped="''${next##*_} ''${stripped}"
        echo $stripped
        next=''${next%_*}
        if [ "$next" == "" ]; then break; fi

        echo "Next try ''${next}"
        if type "${named}''${next}" &> /dev/null; then
          echo "Calling exec ${named}''${next} with args $stripped"
          exec "${named}''${next}" $stripped
        fi
        if [ "$next" == "$prev" ]; then break; fi
        prev=''${next}
      done
      echo "Command not specified"
      listAll
      exit 1
    fi
    '';

  # let cmd = { my = ... }
  # in topLevel
  # > { "bin/my": wrapperScript "my" }
  topLevel = xs: builtins.map wrapperScript (lib.attrNames xs);

  toHM = lib.mapAttrs (name: value:
    { executable = true;
      text = value; }
    );
in {
  meta.maintainers = [ lib.maintainers.sorki ];

  options = {
    home.cmd = lib.mkOption {
      # XXX /o\
      #type = let t = types.either types.str (types.attrsOf t); in t;

      type = with lib.types; attrsOf (either str (attrsOf unspecified));

      description = ''
        Create a custom command based on a description

        This will create a toplevel script which is able
        to find and executes its subcommands.

        It provides a quick way to define ad-hoc command line interfaces.

        This module is eperimental and subject to change.
      '';
      default = {};
      example = {
        home = rec {
          on = "echo 'Morning!'";
          off = "echo 'Night!'";
          args = "echo $@";
          a = args;
        };
        nih = rec {
          build = "nix-build -A $1";
          eval = "nix eval '(with (import <nixpkgs> {}); $1)'";
          # nih ec 20.03 hello.version
          ec = "nix eval -f channel:nixos-$1 $2";
          fetch = {
            url = "nix-prefetch-url $@";
            git = "nix-prefetch-git $@";
          };
          f = fetch;
          prefetch = fetch;
          gc = "nix-collect-garbage -d";
          store = {
            add = "nix-store --add $1";
            inherit gc;
            ping = "nix ping-store";
            realise = "nix-store  --realise $1";
            size = ''
              for i in $( nix-store -q -R $1 ); do
                s="$( nix-store -q --size $i )"
                echo $s $i
              done | sort -n | awk '{ print $1 / 1024 / 1024, "MB", $2 }'
            '';
          };
          repl = "nix repl";
          r = repl;
          drv = {
            pretty ="cat $1 | pretty-derivation";
            diff ="nix-diff $1 $2";
          };
          edit = "nix edit nixpkgs.$1";
          e = edit;
        };
        nixos.rebuild = "nixos-rebuild switch";
        nixpkgs = rec {
          pin = rec {
            ref = "nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/$1.tar.gz";
            commit = ref;
            head = "nixpkgs pin ref $( git rev-parse HEAD )";
            # nixpkgs pin rev release-20.03
            rev = "nixpkgs pin ref $( git rev-parse $1 )";
            branch = rev;
          };
          prefetch = pin;
        };
        ca = rec {
          c2n = ''
            f=$( echo *.cabal | cut -d'.' -f1 )
            test -f "$f.cabal" || { echo "No .cabal file found"; return 1; }
            cabal2nix . > $f.nix
          '';
          build = "cabal build";
          b = build;
          test = "cabal test";
          t = test;
          vtest = "cabal test --test-show-details=always";
          vt = vtest;
          repl = "cabal repl";
          r = repl;
        };
      };
    };
  };

  config = {
    home.file = toHM binaries;
    # debug.trace = binaries;
  };
}
