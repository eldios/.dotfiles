{
  networking = {
    networkmanager.enable = true;

    dhcpcd.enable = true;

    interfaces = {
      eth0.useDHCP = true;
    };

    hostName = "fsn-c1";
    hostId   = "d34d0101"; # random chars

    firewall.enable = true;
  };
}

# vim: set ts=2 sw=2 et ai list nu