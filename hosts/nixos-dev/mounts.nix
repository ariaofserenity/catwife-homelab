{ config, pkgs, ... }:

{
  homelab.services.nfs.enable = true;
  homelab.services.nfs.mounts = {
    common = {
      remoteHost = "192.168.2.14";
      remotePath = "/mnt/d01/common";
      mountPoint = "/mnt/common";
      options = [ "rw" ];
    };
  };
}
