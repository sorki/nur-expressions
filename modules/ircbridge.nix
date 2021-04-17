{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.ircbridge;

  bridgeExecutable = type: "${pkgs.haskellPackages."ircbridge-ircbot-${type}"}/bin/ircbridge-ircbot-${type}";
  bridgeExec = x: ''
    ${bridgeExecutable x.type} \
      --debug \
      --nick "${x.irc.nick}" \
      --username "${x.irc.username}" \
      --hostname "${x.irc.hostname}" \
      --realname "${x.irc.realname}" \
      --server "${x.irc.host}" \
      --port ${builtins.toString x.irc.port} \
      --burst-length ${builtins.toString x.irc.burstLength} \
      --delay-ms ${builtins.toString x.irc.delayMs} \
      ${lib.concatStringsSep " "  (map (x: ''"${x}"'') x.irc.channels)}
  '';

  bridgeOpts = {
    options = {
      type = mkOption {
        type = types.enum [ "amqp" "zre" "multi" ];
        default = "multi";
      };

      irc = {
        host = mkOption {
          type = types.str;
          default = "localhost";
        };

        port = mkOption {
          type = types.port;
          default = 6667;
        };

        nick = mkOption {
          type = types.str;
          default = "ircbridge";
        };

        realname = mkOption {
          type = types.str;
          default = "ircbridge demo";
          description = "ircbridge IRC realname";
        };

        username = mkOption {
          type = types.str;
          default = "ircbridge";
          description = "ircbridge IRC user name";
        };

        hostname = mkOption {
          type = types.str;
          default = "ircbridge@example.org";
          description = "ircbridge hostname";
        };

        channels = mkOption {
          type = types.listOf types.str;
          default = [ "bottest" ];
        };

        burstLength = mkOption {
          type = types.int;
          default = 2;
          description = "Start rate-limiting after burst of this length was received.";
        };

        delayMs = mkOption {
          type = types.int;
          default = 1000000;
          description = "Delay between messages when rate-limited.";
        };
      };
    };
  };
in
{
  options = {
    services.ircbridge = {
      enable = mkEnableOption "Enable ircbridge";
      instances = mkOption {
        type = types.attrsOf (types.submodule [ bridgeOpts ]);
      };
    };
  };
  config = mkMerge [
    {
      environment.systemPackages = with pkgs; [
        haskellPackages.amqp-utils
        haskellPackages.zre
      ];

    }

    (mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        haskellPackages.ircbridge-zre-util
      ];

      users.users.ircbridge = {
        description = "User for ircbridge";
        group = "ircbridge";
        isSystemUser = true;
      };
      users.groups.ircbridge = {};

      services.zre.services = flip lib.mapAttrsToList (lib.filterAttrs (k: v: builtins.elem v.type ["zre" "multi"]) cfg.instances) (k: v: {
        name = "ircbridge-${k}";
        exe = bridgeExec v;
        after = lib.optional (builtins.elem v.type [ "multi" ]) "rabbitmq.service";
        debug = true;
      });

      systemd.services = flip lib.mapAttrs'
        (lib.filterAttrs (k: v: builtins.elem v.type ["amqp"]) cfg.instances)
        (k: v: lib.nameValuePair "ircbridge-amqp-${k}"
        {
          description = "AMQP ircbridge";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" "rabbitmq.service" ];
          serviceConfig = {
            User = "ircbridge";
            Group = "ircbridge";
            ExecStart = bridgeExec v;
            Restart = "always";
            RestartSec = 1;
            MemoryMax = "100M";
            CPUQuota = "50%";
            # TODO
            # Protect
          };
        });


    })
  ];
}
