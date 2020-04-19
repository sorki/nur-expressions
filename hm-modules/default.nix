rec {
  custom-command = ./custom-command.nix;
  debug = ./debug.nix;
  all = [ custom-command debug ];
}
