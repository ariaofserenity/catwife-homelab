{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../modules/nfs.nix
      ../../modules/bind/bind.nix
    ];

  role = "desktop";

  nfsmounts.mountMedia = true;

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

