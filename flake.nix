{
    description = "home config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, ... }@inputs:
    let 
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [
                ./modules/nixos/base.nix
            ];
          };
          
        nixosConfigurations.nixos-dev = nixpkgs.lib.nixosSystem {
            specialArgs = {inherit inputs;};
            modules = [
              ./modules/nixos/base.nix
              ./hosts/nixos-dev/configuration.nix  
            ];
          };
    };
}