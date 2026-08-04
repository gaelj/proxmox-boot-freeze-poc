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
      # ipAddress = "192.168.0.1";
      ipAddress  = "127.0.0.1";
      ceph = {
        enable = true;
        mgr.enable = true;
        mon.enable = true;
        osd.enable = true;
        mds.enable = true;
        rgw.enable = true;
      };
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
