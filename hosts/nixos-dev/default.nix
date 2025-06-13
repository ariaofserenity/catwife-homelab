{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./mounts.nix
    ];

  role = "desktop";

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

