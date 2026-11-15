{
  description = "neoconf: NUN stack with flake and home-manager";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://umbriel.cachix.org"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "umbriel.cachix.org-1:JfNq/2yg2S6D6z4Z2dVSZrZlDPQTKtexB6GAVLD98nw="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.8.0";
    noctalia = {
      url = "github:noctalia-dev/noctalia/cachix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umbriel.url = "github:noctalia-dev/umbriel/cachix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    helium-browser = {
      url = "github:oxcl/nix-flake-helium-browser";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    let
      system = "x86_64-linux";
      lib = inputs.nixpkgs.lib;
      pkgs = inputs.nixpkgs.legacyPackages.${system};

      mkHost = name: {
        system = ./hosts/${name}/system.nix;
        home = ./hosts/${name}/home.nix;
      };

      hosts = {
        ws = mkHost "ws";
        ms = mkHost "ms";
      };

      mkSystem =
        name: host:
        let
          at = hs: builtins.elem name hs;
          args = {
            inherit inputs at;
            hostName = name;
          };
        in
        lib.nixosSystem {
          inherit system;
          specialArgs = args;
          modules = [
            host.system
            inputs.umbriel.nixosModules.default
            inputs.noctalia.nixosModules.default

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = args;
                users.neo = host.home;
                sharedModules = [
                  inputs.nix-flatpak.homeManagerModules.nix-flatpak
                  inputs.noctalia.homeModules.default
                  inputs.umbriel.homeModules.default
                  inputs.zen-browser.homeModules.default
                  inputs.helium-browser.homeModules.default
                ];
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = lib.mapAttrs mkSystem hosts;

      # Checks for CI
      checks.${system} = {
        formatting = pkgs.runCommand "check-nixfmt" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
          nixfmt --check $(find ${./.} -name '*.nix')
          touch $out
        '';
        deadnix = pkgs.runCommand "check-deadnix" { nativeBuildInputs = [ pkgs.deadnix ]; } ''
          deadnix --fail ${./.}
          touch $out
        '';
      };

      # Formatter
      formatter.${system} = pkgs.nixfmt;
    };
}
