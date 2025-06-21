{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  role = "server"; 

  homelab.acme.enable = false;
  homelab.dns.enable = true;

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