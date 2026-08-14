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
in
{
  sharedConfig = {
    network.interface = "ens18";
  };

  networking = {
    networkmanager.enable = true;
    hostName = lib.mkOverride 1 "vm";
    domain = "home.arpa";
  };

  services.qemuGuest.enable = true;

  fileSystems."/" = {
    autoFormat = true;
    autoResize = true;
  };

  hardware = {
    enableAllHardware = lib.mkDefault true;
    graphics.enable = true;
  };
}
