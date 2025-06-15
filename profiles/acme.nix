{config, pkgs, ...}:

{
  sops.secrets.cfToken = {
    sopsFile = ../secrets/cf.env;
    format = "dotenv";
  };
  
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "ariaserenityvt@gmail.com";

  security.acme.certs."catwife.dev" = {
    domain = "*.catwife.dev";
    extraDomainNames = [ "catwife.dev" ];
    dnsProvider = "cloudflare";
    environmentFile = config.sops.secrets.cfToken.path;
  };
}