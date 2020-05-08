{ config, lib, pkgs, ... }:

# this could work equally as a NixOS module
{
  meta.maintainers = [ lib.maintainers.sorki ];

  options = {
    debug.trace = lib.mkOption {
      description = "Call traceSeq on this value";
      default = 42;
    };
  };

  config = {
    warnings = if config.debug.trace != 42 then lib.traceSeq config.debug.trace [] else [];
  };
}
