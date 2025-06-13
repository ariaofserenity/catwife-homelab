{ lib, config, ... }:
with lib;
{
  imports = [
    ./services
    ./system
  ];
}