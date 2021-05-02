{ pkgs }:
pkgs.fetchFromGitHub {
  owner = "haskell-nix";
  repo = "hnix-store";
  rev = "db71ecea3109c0ba270fa98a9041a8556e35217f";
  sha256 = "0var71h0ww7mbxmy6489xkk1lmy8yqrw8nfah2jgndhxlslckf87";
}
