{
  description = "aria config but less cursed";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nixarr.url = "github:rasmus-kirk/nixarr";
    comin = {
      url = "github:nlewo/comin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, comin, ... }@inputs:
    let
      hostModules = {
        feli = import ./hosts/feli;
        marisa = import ./hosts/marisa;
        nixos-dev = import ./hosts/nixos-dev;
        nixos-dev2 = import ./hosts/nixos-dev2;
      };
      
      userModules = {
        aria = import ./home-manager/users/aria;
      };

      hosts = {
        feli = {
          system = "x86_64-linux";
          homeManager = false;
        };
        
        marisa = {
          system = "x86_64-linux"; 
          homeManager = false;
        };
        
        nixos-dev = {
          system = "x86_64-linux"; 
          homeManager = true;
          users = [ "aria" ];
        };

        nixos-dev2 = {
          system = "x86_64-linux"; 
          homeManager = true;
          users = [ "aria" ];
        };
      };

      baseModules = [
        comin.nixosModules.comin
        sops-nix.nixosModules.sops
        ./global
        ./modules/nixos
        {
          services.comin = {
            enable = true;
            remotes = [{
              name = "origin";
              url = "https://github.com/ariaofserenity/catwife-homelab.git";
              branches.main.name = "main";
            }];
          };
        }
      ];

      mkUserConfigs = users: 
        builtins.listToAttrs (map (user: {
          name = user;
          value = userModules.${user};
        }) users);

      mkHost = hostname: 
      assert builtins.hasAttr hostname hostModules;
      let
        hostConfig = hosts.${hostname};
        
        homeManagerModules = if hostConfig.homeManager or false then [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users = mkUserConfigs (hostConfig.users or []);
          }
        ] else [];

      in nixpkgs.lib.nixosSystem {
        system = hostConfig.system or "x86_64-linux";
        specialArgs = { 
          inherit inputs hostname;
          hostConfig = hostConfig;
        };
        modules = baseModules ++ [ hostModules.${hostname} ] ++ homeManagerModules;
      };

    in {
      nixosConfigurations = builtins.mapAttrs (hostname: _: mkHost hostname) hosts;
    };
}