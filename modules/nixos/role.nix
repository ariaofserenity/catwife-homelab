{ lib, ... }:

{
  options.role = lib.mkOption {
    type = lib.types.str;
    description = "type of host";
  };
}