{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nur.url = "github:nix-community/NUR";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    with inputs;
    let
      lib = import ./lib.nix {
        flakeInputsFromFlakeNix = inputs;
        flakeSelfFromFlakeNix = self;
      };
    in {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

      nixosConfigurations.nixos = lib.mkNixosConfiguration {
        hostname = "nixos";
        username = "nixos";
        modules =
          [ nixos-wsl.nixosModules.wsl ./hosts/nixos/configuration.nix ];
      };

      nixosConfigurations.server = lib.mkNixosConfiguration {
        hostname = "server";
        username = "server";
        modules =
          [ nixos-wsl.nixosModules.wsl ./hosts/server/configuration.nix ];
      };
    };
}
