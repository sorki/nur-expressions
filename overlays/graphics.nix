{ pkgs, haskellLib }:
with haskellLib;

(hself: hsuper: {
  # merged, wait next release https://github.com/tobbebex/GPipe-Core/pull/73
  GPipe = doJailbreak hsuper.GPipe;

  # send PR
  GPipe-GLFW = doJailbreak hsuper.GPipe-GLFW;

  nanovg =
    pkgs.importGitHubPR {
      url = "https://github.com/cocreature/nanovg-hs/pull/10";
      sha256 = "1yc1mzvycxa89pssw9yazjvsv8xlnijsbmkvgwp153psdr864plf";
      fetchSubmodules = true;
    } {};

  nanovg-simple =
    self.callCabal2nixOnGitHubPR {
      url = "https://github.com/CthulhuDen/nanovg-simple/pull/1";
      sha256 = "142sci11lwdd3p1vcsmq69hwfkw0qpv2k380cdkqlawnwzh0rzpa";
    } {};
})
