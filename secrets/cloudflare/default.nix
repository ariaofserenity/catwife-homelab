{ config, lib, ... }:
with lib;
{
  options.homelab.secrets.cloudflare = {
        file = mkOption {
            type = types.path;
            default = ./cf.env;
            description = "cloudflare token";
        };
    
        format = mkOption {
            type = types.str;
            default = "dotenv";
            description = "format of secrets file";
        };
  };
}