{ lib
, stdenv
, fetchFromGitHub
, pkg-config
# , linuxHeaders
, kernel
}:

stdenv.mkDerivation rec {
  pname = "looking-glass-module";
  version = "B3";

  src = fetchFromGitHub {
    owner = "gnif";
    repo = "LookingGlass";
    rev = version;
    sha256 = "1vmabjzn85p0brdian9lbpjq39agzn8k0limn8zjm713lh3n3c0f";
    fetchSubmodules = true;
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  # TODO: PR
  postPatch = ''
    echo 'install:' >> Makefile
    echo '	make -C $(KDIR) M=$(PWD) modules_install' >> Makefile
  '';

  sourceRoot = "source/module";
  makeFlags = [ "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build" ];

  INSTALL_MOD_PATH = "\${out}";

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
