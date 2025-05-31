{ config, lib, pkgs, ... }:

{
  imports =
      ./hardware-configuration.nix
    ];

  time.timeZone = "America/New_York";

  networking = {
    interfaces.ens18 = {
      ipv4.addresses = [{
        address = "192.168.2.201";
        prefixLength = "24";
      }];
    };
  };

  users.users.aria = {
      isNormalUser = true;
     extraGroups = [ "wheel" ]; 
     openssh.authorizedKeys.keys = [
	 "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDaGzAqH/9U43Bcvj9XrIWH6urY8o6GzHxBrrQOkoPyuTqPxNQT623O8bCO4SvjaC3Ajv2CLSxDFoLkoxTNPx6YrHTNtNTJOUJT8HkhnxfZKrWRmOt4Xd9agLVbluxGrlgLasfjVF5c1JyWu1/QHh72xqki6mBCfaJMtYQJHH6mNKqtUr6OBPvtwEEd5DwNIDc/hUURTG8BvqGvt/voxmTxmNOnvf556PmHCrhNyPQ4w/bMhTVQnH8Yyj+hFKgVhpT5xg5C/YFicOgQJMFg0BpOBFXXahx5+LhFwSeSFxfNyRjYO78xMLpIKg+uEcc1vOPAn9Rp/6PSzWTztR87RLG89VBtnPjlzvuWDK4it7cUiYLFFMDJGxFw9hqRSkkv6MHN85mrGCtoHVRRMjHozKEfhzhwfQo/QpbiF/VKXy8SzkhQt7s9ZAMqhfwJkJsDPB8haeN3TJ3GfPjrKL+6R/iYFIvnV6gjFeKD45LEUc1TgZNtHlRiUNlrGot5FRz9NLk= aria@zemuria" ];
     packages = with pkgs; [
       tree
     ];
   };

  environment.systemPackages = with pkgs; [
     vim 
     wget
     git
   ];
}

