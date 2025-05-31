{
    description = "home config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        sops-nix.url = "github:Mic92/sops-nix";
    };

outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";
      userNames = builtins.filter (name:
      (builtins.readDir ./users)."${name}" == "directory" ) (builtins.attrNames (builtins.readDir ./users));
      hostnames = builtins.attrNames (builtins.readDir ./hosts);
      users = builtins.listToAttrs (map (name: {
        name = name;
        value = import (./modules/home-manager/users/${name}/home.nix);
        }) userNames);
    in 
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostnames (hostname:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit users; };
          modules = [
            (import (./hosts + "/${hostname}"))
            ./modules/nixos/base.nix
            sops-nix.nixosModules.sops
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit users; };
              home-manager.users = nixpkgs.lib.mapAttrs (_: import) users;
            }
          ];
        }
      );
    };
}