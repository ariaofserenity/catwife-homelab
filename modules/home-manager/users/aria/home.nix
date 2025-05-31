{ config, pkgs, lib, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
in
{
  home-manager.users.aria = { pkgs, ... }: {
    home.packages = [ pkgs.atool ];
    programs.bash.enable = true;
    home.shellAliases = {
      g = "git";
    };
  
    home.stateVersion = "25.05";
  };
}