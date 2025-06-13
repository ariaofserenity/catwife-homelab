{ lib, config, pkgs, ...}:

with lib;
let
  cfg = config.homelab.services.grocy;
in
{
  options.homelab.services.grocy.enable = mkEnableOption "Grocy";
  config.services.grocy = mkIf cfg.enable {
        enable = true;
        hostName = "nixos-dev";
        dataDir = "/var/lib/grocy";
        settings = {
            currency = "CAD";
        };
    };

}