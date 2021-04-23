{ pkgs, haskellLib }:
with haskellLib;

let
  pipsWorkspace = pkgs.fetchFromGitHub {
    owner = "homectl";
    repo = "workspace";
    rev = "";
    sha256 = "";
  };

  localPipsWorkspace = sub: /home/srk/homectl/workspace + "/${sub}";

  # mono =
  # parseCabal packages: folder/ ..
in

(hself: hsuper:
  let
    pipsPackage = { name, args ? {} }: hsuper.callCabal2nix name "${pipsWorkspace}/${name}" args;
    localPipsPackage = { name, args ? {} }: hsuper.callCabal2nix name "${localPipsWorkspace name}" args;
  in
  {
    # from workspace
    linear = hsuper.linear.override { lens = hsuper.lens_5_0_1; };
    # GPipe-Core = localPipsPackage { name = "GPipe-Core"; args = { lens = hsuper.lens_5_0_1; }; };
    GPipe-GLFW4 = haskellLib.dontCheck ( localPipsPackage { name = "GPipe-GLFW4"; } );

    # from git
    # GPipe-Core = pipsPackage { name = "GPipe-Core"; args = { lens = hsuper.lens_5_0_1; }; };
    # GPipe-GLFW4 = pipsPackage { name = "GPipe-GLFW4"; };
    #
    # local
    GPipe-Core = hsuper.callCabal2nix "GPipe-Core"  /home/srk/homectl/GPipe-Core { lens = hsuper.lens_5_0_1; };


  /*
  linear = hsuper.linear.override { lens = hsuper.lens_5_0_1; };
  GPipe-Core = hsuper.callCabal2nix "GPipe-Core"  /home/srk/homectl/GPipe-Core { lens = hsuper.lens_5_0_1; };
  GPipe-Core = hsuper.callCabal2nix "GPipe-Core" (pkgs.fetchFromGitHub {
    owner = "homectl";
    repo = "GPipe-Core";
    rev = "b97b51a07a51a19d8b25180d31d88ba7dc5e36b1";
    sha256 = "05gpajx2bgay8dv09mglyih5yh0ibx5yiqaxmskdx430y3l3j68x";
  }) { lens = hsuper.lens_5_0_1; };
  GPipe-GLFW4 = dontCheck ( hsuper.callCabal2nix "GPipe-GLFW4" (pkgs.fetchFromGitHub {
    owner = "homectl";
    repo = "GPipe-GLFW4";
    rev = "f91b5cf934f4b8114d7eb1a42ef64a9760aa8495";
    sha256 = "1ih99rlzk0r3rb8l6pynkvh3v9ak335kvc26yndcp3h1kcz521k8";
  }) {});
  */

  implicit =
    dontCheck (hsuper.callCabal2nix "implicit" /home/srk/git/ImplicitCAD { quickspec = null; });
  
  nanovg =
    hsuper.callCabal2nix "nanovg" /home/srk/git/nanovg {
      GLEW = null;
      inherit (pkgs) freetype;
      inherit (pkgs) glew;
      inherit (pkgs) libGL;
      inherit (pkgs) libGLU;
      inherit (pkgs.xorg) libX11;
    };
    #import /home/srk/git/nanovg {};
  #  pkgs.importGitHubPR {
  #    url = "https://github.com/cocreature/nanovg-hs/pull/10";
  #    sha256 = "1yc1mzvycxa89pssw9yazjvsv8xlnijsbmkvgwp153psdr864plf";
  #    fetchSubmodules = true;
  #  } {};

  nanovg-simple =
    import /home/srk/git/nanovg-simple {};
    #callCabal2nixOnGitHubPR {
    #  url = "https://github.com/CthulhuDen/nanovg-simple/pull/1";
    #  sha256 = "142sci11lwdd3p1vcsmq69hwfkw0qpv2k380cdkqlawnwzh0rzpa";
    #} {};

  nanovg-blendish = hsuper.callCabal2nix "nanovg-blendish" /home/srk/git/nanovg-blendish {};
      #url = "https://github.com/sorki/nanovg-blendish/";
      # sha256 = "142sci11lwdd3p1vcsmq69hwfkw0qpv2k380cdkqlawnwzh0rzpa";
      # } {};

  # All hope lost
  #
  # merged, wait next release https://github.com/tobbebex/GPipe-Core/pull/73
  GPipe = doJailbreak hsuper.GPipe;

  # merged, wait next release
  GPipe-GLFW = doJailbreak hsuper.GPipe-GLFW;

})
