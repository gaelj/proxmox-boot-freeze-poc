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
  # User account with sudo privileges
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos"; # Change this!
  };

  home-manager.users.nixos =
    { osConfig, lib, ... }:
    let
      inherit (osConfig.networking) hostName;
      homeStateVersions = {
        "vm" = "26.11";
      };
    in
    {
      imports = [
        self'.homeModules.base-user-defaults
      ];

      home.stateVersion = lib.mkForce homeStateVersions.${hostName};

      sharedConfig = {
        name = "nixos";
        email = "nixos@dummy.com";
        sshAuthorizedKeyFiles = [ ];
        software.zsh.enable = true;
        stylixUser.enable = true;
      };
    };
}
