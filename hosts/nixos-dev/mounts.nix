{ config, pkgs, lib, ... }:

{

   homelab.services.nfs.mounts = {
    media = {
      remoteHost = "192.168.1.14";
      remotePath = "/mnt/d01/common";
      mountPoint = "/mnt/common";
      options = [ "rw" ];
    };

    media = {
      remoteHost = "192.168.1.14";
      remotePath = "/mnt/d01/media";
      mountPoint = "/mnt/media";
      options = [ "rw" ];
    };
  };
}