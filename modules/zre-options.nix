{ lib }:

with lib;
{
  name = mkOption {
    type = types.nullOr types.str;
    default = null;
  };

  after = mkOption {
    type = types.listOf types.str;
    default = [];
    description = "Start this service after the ones listed here";
  };

  exe = mkOption {
    type = types.nullOr types.str;
    default = null;
    description = "Executable";
  };

  builtin = mkOption {
    type = types.nullOr (types.enum [ "zretime" "zgossip-server" ]);
    default = null;
  };

  gossip = {
    host = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        Host of the ZGossip service used by this service.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 31337;
      description = ''
        Port number of the ZGossip service used by this service.
      '';
    };
  };

  interface = mkOption {
    type = types.nullOr types.str;
    default =  null; # "localhost";
    description = ''
      Interface to bind this service to.
    '';
  };

  debug = mkEnableOption "Enable debugging output for this service";

  quiet-period = mkOption {
    type = types.ints.positive;
    default = 5;
    description = ''
      Number of seconds after which the peer is considered quiet.
    '';
  };
  dead-period = mkOption {
    type = types.ints.positive;
    default = 10;
    description = ''
      Number of seconds after which the peer is considered dead.
    '';
  };
  beacon-period = mkOption {
    type = types.ints.positive;
    default = 1;
    description = ''
      Period for sending multicast beacons.
    '';
  };

  multicastGroup = {
    address = mkOption {
      type = types.str;
      default = "225.25.25.25";
      description = ''
        Address of the multicast group to use for ZRE UDP beacons.
      '';
    };
    port = mkOption {
      type = types.port;
      default = 5670;
      description = ''
        Port of the multicast group to use for ZRE UDP beacons.
      '';
    };
  };
}
