{ lib, config, pkgs, ...}:

with lib;
let
  cfg = config.homelab.dns;
in
{
  options.homelab.dns.enable = mkEnableOption "BIND";
  config = mkIf cfg.enable {
       
       system.activationScripts.bind-zones.text = ''
        mkdir -p /etc/bind/zones
        chown named:named /etc/bind/zones
        '';

        environment.etc."bind/zones/catwife.dev.zone" = {
            enable = true;
            user = "named";
            group = "named";
            mode = "0644";
            text = builtins.readFile ./catwife.dev.zone;
        };
       
       services.bind = {
        enable = true;
        zones."catwife.dev" = {
            file = "/etc/bind/zones/catwife.dev.zone";
            master = true;
        };
       };

       networking.firewall = {
            allowedTCPPorts = [ 53 ];
            allowedUDPPorts = [ 53 ];
       };
    };
}