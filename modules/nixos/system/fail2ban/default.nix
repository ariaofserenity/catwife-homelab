{ config, lib, pkgs, ...}:

with lib;

let
    cfg = config.homelab.system.fail2ban;
in
{
    options.homelab.system.fail2ban.enable = mkEnableOption "fail2ban";

    config = mkIf config.homelab.system.fail2ban.enable {
          services.fail2ban = {
            enable = true;
            maxretry = 5;
            bantime = "24h";
                bantime-increment = {
                enable = true;
                multipliers = "1 2 4 8 16 32 64";
                maxtime = "168h";
                overalljails = true;
            };
        };
    };
}