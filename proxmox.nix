{
  pkgs,
  system,
  lib,
  ...
}:
{
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
