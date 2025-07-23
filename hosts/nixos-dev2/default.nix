{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];
      
  #homelab.acme.enable = true;
  #homelab.services.grocy.enable = true;

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

