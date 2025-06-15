{ lib, config, pkgs, ...}:

with lib;
let
  cfg = config.homelab.services.grocy;
in
{
  options.homelab.services.grocy.enable = mkEnableOption "Grocy";
  config = mkIf cfg.enable {
        services.grocy = {
        enable = true;
        hostName = "catwife.dev";
        dataDir = "/var/lib/grocy";
        settings.currency = "CAD";
        };

      networking.firewall.allowedTCPPorts = [ 80 443 ];
    };
}