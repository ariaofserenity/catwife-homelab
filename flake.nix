{
    description = "home config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        sops-nix.url = "github:Mic92/sops-nix";
        nixarr.url = "github:rasmus-kirk/nixarr";
        comin.url = "github:nlewo/comin";
        comin.inputs.nixpkgs.follows = "nixpkgs"; 
    };

outputs = { self, nixpkgs, home-manager, sops-nix, comin, ... }@inputs:
    let
      system = "x86_64-linux";
      users = builtins.filter (name:
      (builtins.readDir ./home-manager/users).${name} == "directory"
      ) (builtins.attrNames (builtins.readDir ./home-manager/users));
      hostnames = builtins.attrNames (builtins.readDir ./hosts);
    in 
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hostnames (hostname:
        let
          hostModule = import ./hosts/${hostname};
          roleModule = { config, ... }: { _module.args.role = config.role or null; };
          cominModule = {
            services.comin = {
              enable = true;
              remotes = [
                {
                  name = "origin";
                  url = "https://github.com/ariaofserenity/catwife-homelab.git";
                  branches.main.name = "main";
                }
              ];
            };
          };
          baseModules = [
            comin.nixosModules.comin
            sops-nix.nixosModules.sops
            hostModule
            roleModule
            cominModule
            ./global/global.nix
            ./global/role.nix
            ./modules/nixos
          ];
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit users inputs;
          };
          modules = baseModules ++ (
            if (hostModule { config = {}; }).role == "desktop" then [
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.extraSpecialArgs = { inherit users; };
                home-manager.users = builtins.listToAttrs (map (name: {
                name = name;
                value = import ./home-manager/users/${name}/home.nix;
                }) users);
              }
            ] else []
          );
        }
      );
    };
}