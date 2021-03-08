import <nixpkgs/nixos/tests/make-test-python.nix> ({pkgs, ...}: rec {
  name = "ircbridge";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ sorki ];
  };

  machine = {
    imports = [
      # <nixpkgs/nixos/modules/profiles/minimal.nix>
      ../modules/amqp.nix
      ../modules/ircbridge.nix
      ../modules/zre.nix
      ../modules/charybdis.nix
    ];

    nixpkgs.overlays = (import ~/git/nur/srk-nur-expressions {}).overlays.all;

    services.ircbridge = {
      enable = true;
      instances = {
        one.irc.nick = "bot-one";
        two.irc.nick = "bot-two";
        three = {
          irc.nick = "bot-three";
          type = "amqp";
        };
        four = {
          irc.nick = "bot-four";
          type = "zre";
        };
      };
    };

    my.services.amqp.enable = true;
    my.services.testing-irc.enable = true;

    services.zre = {
      enable = true;
      globalConfig = true;
      gossip.enable = true;

      # XXX:
      openFirewall = true;
      gossip.openFirewall = true;
    };

    services.mingetty.autologinUser = "root";
    environment.systemPackages = with pkgs; [
      irssi
      pkgs.haskellPackages.polytype
    ];

    virtualisation.memorySize = 2*1024;
    virtualisation.diskSize = 1024;
    virtualisation.cores = 2;
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("charybdis.service")
    machine.wait_for_unit("rabbitmq.service")
    machine.wait_for_unit("zre-ircbridge-one.service")
    machine.wait_for_unit("zre-ircbridge-two.service")
    machine.sleep(30)  # give ircbot some time to connect
    print(machine.succeed("polytype-ircbridge-test"))
  '';
})
