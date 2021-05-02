{ pkgs }:
pkgs.fetchFromGitHub {
  owner = "sorki";
  repo = "factoids";
  rev = "ec144bc6c6a4cf6b9541a36a845e4f4df2158783";
  sha256 = "1p0pd7vyimyzpdlbc4wfrhlk8m91chiapmqhax541p3p52r3dkqy";
}
