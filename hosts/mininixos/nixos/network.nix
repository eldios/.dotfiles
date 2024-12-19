{
  networking = {
    dhcpcd.enable = true;
    usePredictableInterfaceNames = true;

    interfaces = {
      eno1 = {
        macAddress = "1c:69:7a:0e:15:6d";
      };

      br0 = {
        useDHCP = true;
        ipv4.addresses = [{
          address = "192.168.155.111";
          prefixLength = 21;
        }];
      };
    };

    bridges = {
      br0 = {
        interfaces = [ "eno1" ];  # Replace with your actual network interface
      };
    };

    #defaultGateway = "192.168.1.1";
    #nameservers = [ "1.1.1.1" "8.8.8.8" ];

    hostName = "mininixos";
    hostId   = "d34d0003"; # random chars

    firewall = {
      enable = false;
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      checkReversePath = false;
      trustedInterfaces = [ "br0" ];
    };
  };
}

# vim: list nu ts=2 sw=2 et ai
