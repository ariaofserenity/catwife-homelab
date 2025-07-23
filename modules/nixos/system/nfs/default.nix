{ config, lib, pkgs, ... }:

let
  cfg = config.homelab.system.nfs;
in
{
  options.homelab.system.nfs = {
    enable = lib.mkEnableOption "Enable mounting of NFS shares";

    mounts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          remoteHost = lib.mkOption {
            type = lib.types.str;
            description = "Remote NFS server IP or hostname.";
          };
          remotePath = lib.mkOption {
            type = lib.types.str;
            description = "Path on the remote server to mount.";
          };
          mountPoint = lib.mkOption {
            type = lib.types.str;
            description = "Local mount point path.";
          };
          options = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "rw" ];
            description = "Mount options.";
          };
        };
      }));
      default = {};
      description = "NFS mounts to create.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.mapAttrsToList (_: mountCfg:
      "d ${mountCfg.mountPoint} 0755 root root -"
    ) cfg.mounts;

    fileSystems = lib.mkMerge (
      lib.mapAttrsToList (_: mountCfg: {
        "${mountCfg.mountPoint}" = {
          device = "${mountCfg.remoteHost}:${mountCfg.remotePath}";
          fsType = "nfs";
          options = mountCfg.options;
        };
      }) cfg.mounts
    );
  };
}