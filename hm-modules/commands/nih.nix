rec {
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
}
