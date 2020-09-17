{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my.services.testing-irc;
in
{
  options = {
    my.services.testing-irc.enable = mkEnableOption "local charybdis instanace";
  };

  config = mkIf cfg.enable {
    services.charybdis = {
      enable = true;
      config = builtins.readFile ../files/ircd.conf.example;
    };
  };
}
