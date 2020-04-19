{ config, lib, pkgs, ... }:

# this could work equally as a NixOS module
{
  meta.maintainers = [ lib.maintainers.sorki ];

  options = {
    debug.trace = lib.mkOption {
      description = "Call traceSeq on this value";
    };
  };

  config = {
    warnings = lib.traceSeq config.debug.trace [];
  };
}
