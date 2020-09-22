{ config, pkgs, lib, ... }:

with lib;

let
  dataDir = "/var/lib/emci";
  cfg = config.services.emci;
  emciPath = with pkgs; [
    haskellPackages.emci
    nix
    # better use?
    #config.nix.package.out
    coreutils
    gnutar
    gzip
    gitMinimal
    xz.bin
    iproute # updater launches git-post-receive-hook-zre
  ];
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
      path = emciPath;
      script = ''
        emci -c ${cfg.conf} mirror init
      '';

      environment = config.nix.envVars //
        { inherit (config.environment.sessionVariables) NIX_PATH;
        };

      serviceConfig = {
        Type = "oneshot";
        User = "emci";
        WorkingDirectory = "${dataDir}";
        PassEnvironment = "NIX_PATH";
      };
    };
    # XXX: add timer for init or trigger by commit to meta repo

    systemd.services.emci-updater = {
      description = "Periodic emci update";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" "emci-init.service" ];
      requires = [ "emci-init.service" ];
      path = emciPath;

      environment = config.nix.envVars //
        { inherit (config.environment.sessionVariables) NIX_PATH;
        };

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
      timerConfig.OnUnitInactiveSec = 60;
    };
  };
}
