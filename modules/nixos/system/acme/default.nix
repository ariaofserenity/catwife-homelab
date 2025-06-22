{ config, lib, pkgs, ... }:

with lib;

{
  options.homelab.acme.enable = mkEnableOption "Wildcard ACME using Cloudflare";

  config = mkIf config.homelab.acme.enable {
    sops.secrets.cfToken = {
      sopsFile = ../../../../secrets/cf.env;
      format = "dotenv";
    };

    security.acme = {
      acceptTerms = true;
      defaults.email = "ariaserenityvt@gmail.com";

      certs."catwife.dev" = {
        domain = "*.catwife.dev";
        extraDomainNames = [ "catwife.dev" ];
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