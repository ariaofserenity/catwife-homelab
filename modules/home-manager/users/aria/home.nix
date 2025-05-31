{ config, pkgs, lib, ... }:
{
    home.packages = [ pkgs.atool ];
    programs.bash.enable = true;
    programs.bash.shellAliases = {
      ge = "git";
    };
    home.file."hello.txt".text = "home-manager works!";
  
    home.stateVersion = "25.05";
}