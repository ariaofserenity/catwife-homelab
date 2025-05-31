{ lib, pkgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  role = "server";

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

