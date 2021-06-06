{ pkgs }:
pkgs.fetchFromGitHub {
    owner = "sorki";
    repo = "git-post-receive";
    rev = "f283499f1216102b1e5a6c26630050c77f18f134";
    sha256 = "1v6dgj2i0m2qzy56aszb3z90c8kj3ksgk680c62qya39xp266qdi";
}
