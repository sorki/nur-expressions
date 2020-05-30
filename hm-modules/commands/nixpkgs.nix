rec {
  pin = rec {
    ref = "nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/$1.tar.gz";
    commit = ref;
    head = "nixpkgs pin ref $( git rev-parse HEAD )";
    # nixpkgs pin rev release-20.03
    rev = "nixpkgs pin ref $( git rev-parse $1 )";
    branch = rev;
  };
  prefetch = pin;
}
