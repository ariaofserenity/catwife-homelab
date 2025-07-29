{ config, lib, ... }:
with lib;
{
  options.homelab.secrets.forgejo = {
        file = mkOption {
            type = types.path;
            default = ./forgejo-secrets.yaml;
            description = "forgejo password";
        };
    
        format = mkOption {
            type = types.str;
            default = "yaml";
            description = "format of secrets file";
        };
  };
}