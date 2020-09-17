{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.my.services.amqp;
in
{
  options = {
    my.services.amqp.enable = mkEnableOption "amqp";
  };

  config = mkIf cfg.enable {
    services.rabbitmq = {
      enable = true;
      configItems = {
        "heartbeat" = "6";
        "tcp_listen_options.keepalive" = "true";
        "tcp_listen_options.send_timeout" = "1500"; # default is 15000
        "management.tcp.ip" = "127.0.0.1";
        "management.tcp.port" = "15672";
      };
      plugins = [ "rabbitmq_management" ];
    };
  };
}
