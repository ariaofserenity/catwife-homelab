{ lib, config, pkgs, ... }:

with lib;
let cfg = config.homelab.services.grocy;
in {
  options.homelab.services.grocy.enable = mkEnableOption "Grocy";
  config = mkIf cfg.enable {
    services.grocy = {
      enable = true;
      hostName = "grocy.catwife.dev";
      nginx.enableSSL = false;
      dataDir = "/var/lib/grocy";
      settings.currency = "CAD";
    };

    services.nginx.virtualHosts."grocy.catwife.dev" = {
      addSSL = true;
      sslCertificate = "/var/lib/acme/catwife.dev/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/catwife.dev/key.pem";
    };
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
