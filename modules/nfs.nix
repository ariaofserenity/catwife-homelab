{ config, lib, ... }:

with lib;

let
  cfg = config.nfsmounts;
in {
  options.nfsmounts = {
    mountCommon = mkOption {
      type = types.bool;
      default = false;
      description = "Mount /mnt/common";
    };

    mountMedia = mkOption {
      type = types.bool;
      default = false;
      description = "Mount /mnt/media";
    };
  };

  config = mkMerge [
    (mkIf cfg.mountCommon {
      fileSystems."/mnt/common" = {
        device = "192.168.2.14:/mnt/d01/common";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
    })

    (mkIf cfg.mountMedia {
      fileSystems."/mnt/media" = {
        device = "192.168.2.14:/mnt/d01/media";
        fsType = "nfs";
        options = [ "x-systemd.automount" "noauto" ];
      };
    })
  ];
}