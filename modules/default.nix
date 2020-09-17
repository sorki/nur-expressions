rec {
  amqp = ./amqp.nix;
  charybdis = ./charybdis.nix;
  emci = ./emci.nix;
  ircbridge = ./ircbridge.nix;
  zre = ./zre.nix;

  all = [
    amqp
    charybdis
    emci
    ircbridge
    zre
  ];
}

