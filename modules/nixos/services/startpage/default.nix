{ lib, config, pkgs, ... }:

with lib;
let cfg = config.homelab.services.startpage;
in {
  options.homelab.services.startpage.enable = mkEnableOption "startpage";
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts."startpage.${config.homelab.domain}" = {
        root = "/var/www/startpage";
        addSSL = true;
        sslCertificate = "/var/lib/acme/${config.homelab.domain}/fullchain.pem";
        sslCertificateKey = "/var/lib/acme/${config.homelab.domain}/key.pem";
        locations."/" = {
          index = "index.html";
        };
      };
    };

   systemd.services.webpageUpdater = {
    serviceConfig = {
      Type = "oneshot";
    };
    script = ''
      export PATH=${pkgs.git}/bin:$PATH
      cd /var/www/startpage
      git pull
      systemctl reload nginx
    '';
  };

  systemd.timers.webpageUpdater = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5min";
      OnUnitActiveSec = "5min";
    };
  };
    
    system.activationScripts.cloneWebpage = {
      text = ''
        if [ ! -d /var/www/startpage/.git ]; then
          export PATH=${pkgs.git}/bin:$PATH
          git clone https://github.com/ariaofserenity/startpage /var/www/startpage
        fi
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
