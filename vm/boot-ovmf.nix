{
  lib,
  pkgs,
  config,
  modulesPath,
  self',
  ...
}:
{
  proxmox.qemuConf.bios = "ovmf";

  boot = {
    # initrd = {
    #   systemd.enable = lib.mkForce true; # set this false to fix the issue
    # };

    loader = {
      # grub.enable = true;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # grub = {
      #   devices = [ "nodev" ];
      #   useOSProber = true;
      # };
    };
  };
}
