{
  networking = {
    networkmanager.enable = true;

    dhcpcd.enable = true;

    interfaces = { };

    hostName = "lelex1yoga";
    hostId   = "d34d0001"; # random chars

    firewall.enable = true;
  };
}

# vim: set ts=2 sw=2 et ai list nu
