{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/emci";
  cfg = config.services.emci;

in
{
  options = {
    services = {
      emci = {
        enable = mkEnableOption "Enable emci";

        conf = mkOption {
          type = types.str;
        };
      };
    };
  };
  config = mkIf cfg.enable {
    users.users.emci = {
      description = "User for emci";
      home = "${dataDir}";
      createHome = true;
      group = "emci";
      extraGroups = [ "libvirtd" ];
    };
    users.groups.emci = {};

    systemd.services.emci-init = {
      description = "emci initialization";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      path = [ pkgs.haskellPackages.emci pkgs.nix pkgs.git ];
      script = ''
        emci -c ${cfg.conf} mirror init
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "emci";
        WorkingDirectory = "${dataDir}";
      };
    };
    # XXX: add timer for init or trigger by commit to meta repo

    systemd.services.emci-updater = {
      description = "Periodic emci update";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "emci-init.target" ];
      requires = [ "emci-init.target" ];
      path = [ pkgs.haskellPackages.emci pkgs.nix pkgs.git ];
      script = ''
        emci -c ${cfg.conf} mirror update
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "emci";
        WorkingDirectory = "${dataDir}";
      };
    };

    systemd.timers.emci-updater = {
      wantedBy = [ "timers.target" ];
      timerConfig.OnUnitInactiveSec = 10;
    };
  };
}
