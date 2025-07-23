{ config, lib, ... }:
with lib;
{
  options.homelab = {
    domain = mkOption {
      type = types.str;
      default = "catwife.dev";
      description = "domain name";
    };

    mail = mkOption {
      type = types.str;
      default = "ariaserenityvt@gmail.com";
      description = "admin email";
    };
  };
}