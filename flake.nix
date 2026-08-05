{
  description = "PoC for https://github.com/NixOS/nixpkgs/issues/539277";

  inputs = {
    nixpkgs.url = "github:gaelj/nixpkgs/gaelj-pkgs";

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";

    flake-parts.url = "github:hercules-ci/flake-parts";

    sharedConfig = {
      url = "gitlab:gaj-nixos/shared";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      proxmox-nixos,
      sharedConfig,
      flake-parts,
    }@inputs:
    let
      inherit (sharedConfig.inputs.flake-utils.lib.system) x86_64-linux;
      inherit (nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ x86_64-linux ];
      imports = [
        sharedConfig.inputs.flake-parts.flakeModules.modules
        sharedConfig.inputs.home-manager.flakeModules.default
      ];
      flake = {
        agenix-rekey = sharedConfig.inputs.agenix-rekey.configure {
          userFlake = self;
          inherit (self) nixosConfigurations;
        };

        nixosModules = {
          proxmox-poc = (
            { system, ... }:
            {
              imports = [
                proxmox-nixos.nixosModules.proxmox-ve
                ./network.nix
                ./proxmox.nix
              ];
              config = {
                nixpkgs.overlays = [
                  proxmox-nixos.overlays.${system}
                ];
              };
            }
          );
        };

        homeModules = {
          base-user-defaults =
            {
              lib,
              username,
              config,
              osConfig,
              ...
            }:
            let
              inherit (osConfig.sharedConfig) flakeMainDir;
              usrECPrivateKeyPath = "${config.home.homeDirectory}/.ssh/id_ed25519_agenix_${username}";
              usrECPublicKey = lib.strings.trim (
                lib.readFile (flakeMainDir + "/users/${username}/resources/age/id_ed25519_agenix_${username}.pub")
              );
            in
            {
              # run `agenix update-masterkeys` after modifying this
              age = {
                # Path to SSH keys to be used as identities in age decryption
                identityPaths = [ usrECPrivateKeyPath ];
                rekey = {
                  # age public key to use as a recipient when rekeying
                  hostPubkey = usrECPublicKey;
                  # identities used to decrypt the stored secrets to rekey them
                  masterIdentities = [
                    {
                      identity = usrECPrivateKeyPath;
                      pubkey = usrECPublicKey;
                    }
                  ];
                };
              };

              sharedConfig = {
                inherit username;
                ohMyPoshTheme = lib.mkDefault "0_gaj";
                stylixUser = {
                  enable = lib.mkDefault true;
                  theme = lib.mkDefault "catppuccin-mocha";
                  polarity = lib.mkDefault "dark";
                };
              };
            };
        };

        nixosConfigurations = {
          proxmox-poc = nixpkgs.lib.nixosSystem {
            system = x86_64-linux;
            specialArgs = (sharedConfig.lib.mkSpecialArgsWithInputsAndLib {
              sharedConfig = sharedConfig.lib;
            }) // { self' = self; };
            modules = [
              sharedConfig.nixosModules.shared-config
              ./vm-configuration.nix
            ];
          };
        };
      };
    };
}
