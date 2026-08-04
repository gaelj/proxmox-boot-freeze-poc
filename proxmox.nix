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
      ipAddress  = "127.0.0.1";
      # ceph = {
      #   enable = true;
      #   mgr = {
      #     enable = true;
      #     daemons = [
      #       "name1"
      #       "name2"
      #     ];
      #   };
      #   mon = {
      #     enable = true;
      #     daemons = [
      #       "name1"
      #       "name2"
      #     ];
      #   };
      #   osd = {
      #     enable = true;
      #     daemons = [
      #       "1"
      #       "2"
      #     ];
      #   };
      #   mds = {
      #     enable = true;
      #     daemons = [
      #       "name1"
      #       "name2"
      #     ];
      #   };
      #   rgw = {
      #     enable = true;
      #     daemons = [
      #       "name1"
      #       "name2"
      #     ];
      #   };
      # };
    };
    nix.settings = {
      substituters = [
        https://cache.saumon.network/proxmox-nixos
      ];
      trusted-public-keys = [
        proxmox-nixos:D9RYSWpQQC/msZUWphOY2I5RLH5Dd6yQcaHIuug7dWM=
      ];
    };
  };
}
