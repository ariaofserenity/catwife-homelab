{ lib, config, pkgs, ... }:

with lib;
let cfg = config.homelab.services.grocy;
in {
  options.homelab.services.grocy.enable = mkEnableOption "Grocy";
  config = mkIf cfg.enable {
    services.grocy = {
      enable = true;
      hostName = "grocy.${config.homelab.domain}";
      nginx.enableSSL = false;
      dataDir = "/var/lib/grocy";
      settings.currency = "CAD";
    };

    services.nginx.virtualHosts."grocy.${config.homelab.domain}" = {
      addSSL = true;
      sslCertificate = "/var/lib/acme/${config.homelab.domain}/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/${config.homelab.domain}/key.pem";
    };
    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
