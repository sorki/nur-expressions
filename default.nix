{ pkgs ? import <nixpkgs> {} }:
{
  # The `lib`, `modules`, and `overlay` names are special
  lib = import ./lib { inherit pkgs; }; # functions
  modules = import ./modules; # NixOS modules
  overlays = import ./overlays; # nixpkgs overlays

  hm-modules = rec {
    modules = builtins.attrValues rawModules;
    rawModules = import ./hm-modules;
  };
}
