{ pkgs }:
# https://github.com/sorki/hnix-store-experiments
pkgs.fetchFromGitHub {
  owner = "sorki";
  repo = "hnix-store-experiments";
  rev = "de43c4d87011cdf5108bfe48e248cc4d80707ddd";
  sha256 = "14kh1mafja74xjy92i2kfiicb3k1d2qkgsrs6vsby5vw2h9kphzr";
}
