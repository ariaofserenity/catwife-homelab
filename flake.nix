{
    description = "home config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
        sops-nix.url = "github:Mic92/sops-nix";
        nixarr.url = "github:rasmus-kirk/nixarr";
    };

outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs:
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
          baseModules = [
            hostModule
            roleModule
            ./global/global.nix
            ./global/role.nix
            ./global/nixos
            sops-nix.nixosModules.sops
          ];
        in
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit users;
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