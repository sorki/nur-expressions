{ config, pkgs, lib, ... }:

with lib;

let
  zre = pkgs.haskellPackages.zre;

  cfg = config.services.zre;

  zreEnv = name: x: pkgs.writeText "zre-env" ''
    [zre]
    name = ${name}
    gossip = ${x.gossip.host}:${builtins.toString x.gossip.port}
    ${optionalString (x.interface != null) ''interface = ${x.interface}''}
    multicast-group = ${x.multicastGroup.address}:${builtins.toString x.multicastGroup.port}

    quiet-period  = ${builtins.toString x.quiet-period}
    dead-period   = ${builtins.toString x.dead-period}
    beacon-period = ${builtins.toString x.beacon-period}

    debug = ${if x.debug then "true" else "false"}
  '';

  mkService = x:
    let nameOrBuiltin = if isNull x.name then x.builtin else x.name;
    in
    (nameValuePair "zre-${nameOrBuiltin}"
       { description = "ZRE service ${nameOrBuiltin}";
         after = [ "network-online.target" ] ++ x.after;
         requires = [ "network-online.target" ] ++ x.after;
         wantedBy = [ "multi-user.target" ];
         environment.ZRECFG = zreEnv nameOrBuiltin x;
         path = [ pkgs.iproute ];
         serviceConfig =
           { ExecStart = if isNull x.builtin then "${x.exe}" else "${zre}/bin/${x.builtin}";
             # mkDefault
             Restart = "always";
             RestartSec = 3;
             PrivateTmp="yes";
             ProtectSystem="yes";
             ProtectHome="yes";
             ProtectDevices="yes";
             ProtectKernelTunables="yes";
             ProtectKernelModules="yes";
             ProtectControlGroups="yes";
             MemoryDenyWriteExecute="yes";
             PrivateMounts="yes";
             DynamicUser="yes";
             MemoryMax = "100M";
             CPUQuota = "50%";
           };
       });

  optz = import ./zre-options.nix { inherit lib; };
  zreService = { name, config, ... }: {
    options = optz;
  };
in
{
  options = {
    services.zre = optz // {
      enable = mkEnableOption "Enable ZRE";
      openFirewall = mkEnableOption "Whether to open firewall for TCP range and UDP port used by ZRE apps";
      globalConfig = mkEnableOption "Create global /etc/zre.conf";

      gossip = {
        host = mkOption {
          type = types.str;
          default = "localhost";
          description = ''
            Host of the ZGossip service used by services.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 31337;
          description = ''
            Port number of the ZGossip service used by services.
          '';
        };

        enable = mkEnableOption "Enable ZGossip TCP discovery service";
        openFirewall = mkEnableOption "Whether to open firewall for TCP port used by ZGossip server";
      };

      services = mkOption {
        type = types.listOf (types.submodule zreService);
        default = [
        ];
        example = literalExample [
          { builtin = "zretime"; }
          { name = "myzreapp";
            exe = pkgs.haskellPackages.zre-something; }
        ];
      };
    };
  };

  config = mkMerge [
    (mkIf config.services.zre.enable {

      networking.firewall.allowedTCPPortRanges = lib.optional
        cfg.openFirewall
        { from = 41000; to = 41100; };

      # make UDP discovery optional?
      networking.firewall.allowedUDPPorts = lib.optional
        cfg.openFirewall
        5670;

      environment = {
        systemPackages = [ zre ];
        etc."zre.conf".source = zreEnv "zre" cfg;
      };

      services.zre.services = [
        { builtin = "zretime"; }
      ];

      systemd.services = listToAttrs (map mkService cfg.services);
    })

    (mkIf config.services.zre.gossip.enable {
      networking.firewall.allowedTCPPorts = lib.optional
        cfg.gossip.openFirewall
        cfg.gossip.port;

      services.zre.services = [
        { builtin = "zgossip-server"; }
      ];

    })
  ];
}
