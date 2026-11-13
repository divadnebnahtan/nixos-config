
{
  description = "NixOS systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkSystem = { hostname, system }:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs;

            unstable = import inputs.nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          };

          modules = [
            ./shared/default.nix
            ./shared/packages.nix
          ] ++ [
            ./hosts/${hostname}
          ];
        };
    in
    {
      nixosConfigurations = {
        laptop = mkSystem {
          hostname = "laptop";
          system = "x86_64-linux";
        };

        desktop = mkSystem {
          hostname = "desktop";
          system = "x86_64-linux";
        };

        nuc = mkSystem {
          hostname = "nuc";
          system = "x86_64-linux";
        };
      };
    };
}
