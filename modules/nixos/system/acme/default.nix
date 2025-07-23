{ config, lib, pkgs, ... }:

with lib;

{
  options.homelab.system.acme.enable = mkEnableOption "Wildcard ACME using Cloudflare";

  config = mkIf config.homelab.system.acme.enable {
    sops.secrets.cfToken = {
      sopsFile = config.homelab.secrets.cloudflare.file;
      format = config.homelab.secrets.cloudflare.format;
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = config.homelab.mail;
      certs.${config.homelab.domain} = {
        domain = "*.${config.homelab.domain}";
        extraDomainNames = [ config.homelab.domain ];
        dnsProvider = "cloudflare";
        environmentFile = config.sops.secrets.cfToken.path;
        group = "nginx";
        webroot = lib.mkForce null;
        listenHTTP = lib.mkForce null;
        s3Bucket = lib.mkForce null;
      };
    };
  };
}