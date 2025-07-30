{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.homelab.system.dns;

  mkLocalData = records: domain:
    let
      aRecords = mapAttrsToList (name: ip:
        "\"${name}.${domain} IN A ${ip}\""
      ) (records.A or {});

      cnameRecords = mapAttrsToList (name: target:
        "\"${name}.${domain} IN CNAME ${target}.${domain}\""
      ) (records.CNAME or {});

      mxRecords = mapAttrsToList (name: mx:
        "\"${name}.${domain} IN MX ${toString mx.priority} ${mx.target}\""
      ) (records.MX or {});
    in
      aRecords ++ cnameRecords ++ mxRecords;

in {
  imports = [ ./dns.nix ];

  config = mkIf cfg.enable {
    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = [ "127.0.0.1" ];
          port = 5353;
          access-control = "${cfg.network} allow";
          verbosity = 1;
          local-zone = [ "\"${cfg.domain}\" static" ];
          local-data = mkLocalData cfg.records cfg.domain;
        };

        forward-zone = [{
          name = ".";
          forward-addr = [
              "1.1.1.1@853#cloudflare-dns.com"
          ];
        }];
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
          mapping = cfg.mappings;
        };
        blocking = {
          denylists = {
            ads = [
              "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            ];
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
