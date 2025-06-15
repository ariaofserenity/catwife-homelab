{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  role = "desktop";
  
  homelab.acme.enable = true;
  homelab.services.grocy.enable = false;

  networking = {
    hostName = "nixos-dev2";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.2.203";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.2.1";
    };
  };
}

