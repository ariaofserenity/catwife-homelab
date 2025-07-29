{ lib, pkgs, config, ... }:

with lib;
let
  cfg = config.homelab.services.forgejo;
  http_port = 3000;
in
{
  options.homelab.services.forgejo.enable = mkEnableOption "forgejo";
  config = mkIf cfg.enable {
    sops.secrets.forgejo-admin-password = {
        sopsFile = config.homelab.secrets.forgejo.file;
        format = config.homelab.secrets.forgejo.format;
        owner = "forgejo";
        mode = "0400";
    };

  services.nginx = {
    virtualHosts."git.${config.homelab.domain}" = {
      addSSL = true;
      sslCertificate = "/var/lib/acme/${config.homelab.domain}/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/${config.homelab.domain}/key.pem";
      extraConfig = ''
        client_max_body_size 512M;
      '';
      locations."/".proxyPass = "http://localhost:${toString http_port}";
    };
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    settings = {
        DEFAULT = {
            APP_NAME = "catwife.dev";
            APP_SLOGAN = "where cursed code resides";
        };
        server = {
            DOMAIN = "git.${config.homelab.domain}";
            ROOT_URL = "https://git.${config.homelab.domain}";
            HTTP_PORT = http_port;
        };
        service.DISABLE_REGISTRATION = true; 
     };
   };

    systemd.services.forgejo.preStart = let
    adminCmd = "${lib.getExe config.services.forgejo.package} admin user";
    pwd = config.sops.secrets.forgejo-admin-password.path;
    user = "aria"; 
  in ''
    ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd})" || true
    ## To forcibly change password on every boot, uncomment below:
    #${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd})" || true
  '';
 };
}