{ lib, config, pkgs, ... }:

with lib;
let cfg = config.homelab.services.startpage;
in {
  options.homelab.services.startpage.enable = mkEnableOption "startpage";
  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      services.nginx.virtualHosts."startpage.catwife.dev" = {
        root = "/var/www/startpage";
      };
    };

    systemd.services.webpageUpdater = {
      description = "Update website files from Git repo";

      timerConfig = {
        OnBootSec = "1min";
        OnUnitActiveSec = "3min";
      };
      wants = [ "webpageUpdater.timer" ];

      serviceConfig = {
        Type = "oneshot";
        WorkingDirectory = "/var/www/startpage";
        ExecStart = ''
          git pull origin main
        '';
        User = "root";
        Group = "root";
      };
    };

    systemd.timers.webpageUpdater = { wantedBy = [ "timers.target" ]; };
    
    system.activationScripts.cloneWebpage = {
      text = ''
        if [ ! -d /var/www/startpage/.git ]; then
          git clone https://github.com/ariaofserenity/startpage /var/www/startpage
        fi
      '';
    };

    networking.firewall.allowedTCPPorts = [ 80 ];
  };
}
