{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, obs-studio
, libbfd
, libGLU
, libX11
}:

stdenv.mkDerivation rec {
  pname = "looking-glass-obs";
  version = "B3";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "1vmabjzn85p0brdian9lbpjq39agzn8k0limn8zjm713lh3n3c0f";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    obs-studio
    libX11
    libGLU
    libbfd
  ];

  sourceRoot = "source/obs";
  NIX_CFLAGS_COMPILE = "-mavx"; # Fix some sort of AVX compiler problem.

  installPhase = let
    pluginPath = {
      i686-linux = "bin/32bit";
      x86_64-linux = "bin/64bit";
    }.${stdenv.targetPlatform.system} or (throw "Unsupported system: ${stdenv.targetPlatform.system}");
    pluginDir = "$out/share/obs/obs-plugins/looking-glass-obs/${pluginPath}";
  in ''
    ls -lR .
    mkdir -p ${pluginDir}
    cp liblooking-glass-obs.so ${pluginDir}
  '';

  meta = with lib; {
    description = "A KVM Frame Relay (KVMFR) implementation";
    longDescription = ''
      Looking Glass is an open source application that allows the use of a KVM
      (Kernel-based Virtual Machine) configured for VGA PCI Pass-through
      without an attached physical monitor, keyboard or mouse. This is the final
      step required to move away from dual booting with other operating systems
      for legacy programs that require high performance graphics.
    '';
    homepage = "https://looking-glass.io/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ alexbakker sorki ];
    platforms = [ "x86_64-linux" ];
  };
}
