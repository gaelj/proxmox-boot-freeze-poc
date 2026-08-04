{
  description = "PoC for https://github.com/NixOS/nixpkgs/issues/539277";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    proxmox-nixos.url = "github:SaumonNet/proxmox-nixos";
  };

  outputs =
    {
      self,
      nixpkgs,
      proxmox-nixos,
    }@inputs:
    {
      nixosModules = {
        proxmox-poc = (
          { ... }:
          {
            imports = [
              proxmox-nixos.nixosModules.proxmox-ve
              ./network.nix
              ./proxmox.nix
              ./vm.nix
            ];
            config = {
              nixpkgs.overlays = [
                proxmox-nixos.overlays.${system}
              ];
            };
          }
        );
      };
      nixosConfigurations.proxmox-poc = nixpkgs.lib.nixosSystem {
        modules = [ ./vm-configuration.nix ];
      };
    };
}
