{ config, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ../../modules/nfs.nix
    ];

  role = "desktop";

  nfsmounts.mountMedia = true;

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

