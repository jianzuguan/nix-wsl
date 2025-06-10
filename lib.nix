{ flakeInputsFromFlakeNix, flakeSelfFromFlakeNix }:
let
  inherit (flakeInputsFromFlakeNix) nixpkgs nixpkgs-unstable nur home-manager nix-index-database;

  nixpkgsWithOverlays = system: (import nixpkgs rec {
    inherit system;

    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        # FIXME:: add any insecure packages you absolutely need here
      ];
    };

    overlays = [
      nur.overlays.default

      (_final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (prev) system;
          inherit config;
        };
      })
    ];
  });

  configurationDefaults = args: {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "hm-backup";
    home-manager.extraSpecialArgs = args;
  };

  argDefaults = {
    inputs = flakeInputsFromFlakeNix;
    self = flakeSelfFromFlakeNix;
    inherit nix-index-database; # from flakeInputsFromFlakeNix.nix-index-database
    channels = {
      inherit nixpkgs nixpkgs-unstable; # from flakeInputsFromFlakeNix
    };
  };

  mkNixosConfiguration = {
    system ? "x86_64-linux",
    hostname,
    username,
    args ? {},
    modules,
  }: let
    specialArgs = argDefaults // {inherit hostname username;} // args;
  in
    nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      pkgs = nixpkgsWithOverlays system;
      modules =
        [
          (configurationDefaults specialArgs)
          home-manager.nixosModules.home-manager
        ]
        ++ modules;
    };
in {
  inherit mkNixosConfiguration;
}
