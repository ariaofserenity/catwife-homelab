{ config, pkgs, ... }:

{
  homelab.system.nfs.enable = true;
  homelab.system.nfs.mounts = {
    common = {
      remoteHost = "192.168.2.14";
      remotePath = "/mnt/d01/common";
      mountPoint = "/mnt/common";
      options = [ "rw" ];
    };
  };
}
