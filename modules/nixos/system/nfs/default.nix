{ config, lib, ... }:

let
  cfg = config.homelab.services.nfs;
in
{
  options.homelab.services.nfs = {
    mounts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
        options = {
          remoteHost = lib.mkOption {
            type = lib.types.str;
            description = "Remote NFS host";
          };

          remotePath = lib.mkOption {
            type = lib.types.str;
            description = "Remote path to export";
          };

          mountPoint = lib.mkOption {
            type = lib.types.str;
            description = "Local mount point";
          };

          options = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ "rw" "hard" "intr" ];
            description = "Mount options";
          };
        };
      }));
      default = {};
      description = "Set of NFS mounts keyed by name";
    };
  };

  config = lib.mkIf (cfg.mounts != {}) {
    fileSystems = lib.mkMerge (lib.attrValues (lib.mapAttrsToList (_name: mountCfg: {
      "${mountCfg.mountPoint}" = {
        device = "${mountCfg.remoteHost}:${mountCfg.remotePath}";
        fsType = "nfs";
        options = mountCfg.options;
      };
    }) cfg.mounts));
  };
}