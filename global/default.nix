{ config, lib, pkgs, inputs, ... }:

{
  imports = [ ../users/aria.nix ];
  time.timeZone = "America/New_York";
  services.xserver.xkb.layout = "us";

  networking = {
    nameservers = [ "192.168.2.5" "1.1.1.1" ];
    search = [ "catwife.dev" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 3d";
  };

  environment.systemPackages = with pkgs; [
    fail2ban
    python3
    git
    wget
    curl
    age
    sops
    killall
    dig
  ];

  sops.age.keyFile = "/etc/age/age.key";

  virtualisation.docker.enable = true;

  homelab.system.fail2ban.enable = true;

  system.stateVersion = "25.05";
}
