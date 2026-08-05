{
  lib,
  pkgs,
  config,
  modulesPath,
  self',
  ...
}:
let
  inherit (config.networking) hostName;
  inherit (config.sharedConfig) flakeRoot flakeMainDir;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/proxmox-image.nix")
    ./age.nix
    ./boot.nix
    # ./boot-ovmf.nix
    ./boot-seabios.nix
    ./hardware.nix
    ./user.nix
  ];

  system.stateVersion = "26.11";

  sharedConfig = {
    flakeRoot = ../.;
    flakeMainDir = ../flake;
    stylixGlobal = {
      enable = lib.mkDefault true;
      theme = lib.mkDefault "catppuccin-mocha";
      polarity = lib.mkDefault "dark";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
