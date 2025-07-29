{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./dns.nix
    ];

  homelab.system.acme.enable = false;

  networking = {
    hostName = "feli";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.2.5";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.2.1";
    };
  };
}