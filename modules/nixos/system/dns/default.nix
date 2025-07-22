{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.homelab.dns;
  net = builtins.fromJSON (builtins.readFile ../../../../network.json);
  
  mkLocalData =
  (lib.mapAttrsToList (name: ip:
    "\"${name} IN A ${ip}\""
  ) net.records.A);
in
{
  options.homelab.dns.enable = mkEnableOption "Enable local DNS with Unbound and Blocky";

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = [ "127.0.0.1" ];
          port = 5353;
          access-control = "192.168.2.0/24 allow";
          verbosity = 1;

          
          local-zone = [ "\"${net.domain}\" static" ];
          local-data = mkLocalData;
        };
      };
    };

   services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;
      upstreams.groups.default = [
        "127.0.0.1:5353"
        "1.1.1.1"
      ];
      conditional = {
        fallbackUpstream = true;
        mapping = {
          "catwife.dev." = "127.0.0.1:5353";
          "gf-dis.catwife.dev" = "1.1.1.1";
          "aria.catwife.dev" = "1.1.1.1";
        };
      };
      
      blocking = {
        denylists = {
          ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
         
        };

        clientGroupsBlock = {
          default = [ "ads" ];
        };
      };
    };
  };

    networking.firewall.allowedTCPPorts = [ 53 5353 3000 ];
    networking.firewall.allowedUDPPorts = [ 53 5353 ];
  };
}