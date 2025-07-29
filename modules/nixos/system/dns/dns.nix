{ lib, ... }:
with lib;
let
  # validation
  recordTypes = {
    A = types.attrsOf (types.strMatching "^([0-9]{1,3}\\.){3}[0-9]{1,3}$");
    CNAME = types.attrsOf types.str;
    MX = types.attrsOf (types.submodule {
      options = {
        priority = mkOption { type = types.int; };
        target = mkOption { type = types.str; };
      };
    });
  };
in
{
  options.homelab.system.dns = {
    enable = mkEnableOption "Enable local DNS with Unbound and Blocky";

    domain = mkOption {
      type = types.str;
      default = "";
      description = "domain name";
    };

    network = mkOption {
      type = types.str;
      default = "192.168.2.0/24";
      description = "cidr";
    };

    records = mkOption {
      type = types.submodule {
        options = {
          A = mkOption {
            type = recordTypes.A;
            default = {};
            description = "A records";
          };
          CNAME = mkOption {
            type = recordTypes.CNAME;
            default = {};
            description = "CNAME records";
          };
          MX = mkOption {
            type = recordTypes.MX;
            default = {};
            description = "MX records";
          };
        };
      };
      default = {};
    };

    mappings = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = "forward mappings";
    };

  };
}