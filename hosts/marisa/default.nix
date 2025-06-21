{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./mounts.nix
    ];

  role = "server"; 

  homelab.acme.enable = true;
  homelab.services.grocy.enable = true;
  homelab.services.startpage.enable = true;

  networking = {
    hostName = "marisa";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.2.210";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.2.1";
    };
  };
}