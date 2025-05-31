{
    description = "home config";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, ... } @ inputs:
    let 
        system = "x86_64-linux";
        pkgs = nixpkgs.legacyPackages.${system};
    in
    {
        nixosConfigurations.default = nixpkgs.lib.nixosSystem {
            extraSpecialArgs = {inherit inputs;};
            modules = [
                ./modules/nixos/base.nix
            ];
          };
          nixos-dev = nixpkgs.lib.nixosSystem {
            extraSpecialArgs = {inherit inputs;};
            modules = [
              ./hosts/nixos-dev/configuration.nix  
            ];
          }
    };
}