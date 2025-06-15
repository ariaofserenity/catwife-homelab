{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./mounts.nix
      ../../profiles/acme.nix
    ];

  role = "desktop";
  
  homelab.services.grocy.enable = false;

  networking = {
    hostName = "nixos-dev";
    interfaces = {
      ens18.ipv4.addresses = [{
        address = "192.168.2.201";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "192.168.2.1";
    };
  };
}

