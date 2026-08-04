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
    }:
    {
      nixosModules = {
        proxmox-poc = (
          {
            pkgs,
            system,
            lib,
            ...
          }:
          {
            imports = [
              proxmox-nixos.nixosModules.proxmox-ve
            ];
            config = {
              services.proxmox-ve = {
                enable = true;
                ipAddress = "192.168.0.1";
              };

              nixpkgs.overlays = [
                proxmox-nixos.overlays.${system}
              ];
            };
          }
        );
      };
    };
}
