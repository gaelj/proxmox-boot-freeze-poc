{
  lib,
  pkgs,
  config,
  modulesPath,
  self',
  ...
}:
{
  # systemd-boot requires 'ovmf' bios
  proxmox.qemuConf = {
    bios = "seabios";
    # boot = "order=scsi0;net0";
  };
  proxmox.partitionTableType = "legacy+gpt";

  boot = {
    # initrd = {
    #   systemd.enable = true;
    # };

    loader = {
      # systemd-boot.enable = false;
      # efi.canTouchEfiVariables = false;

      grub = {
        #enable = true;
        # device = lib.mkDefault "/dev/vda";
        # device = "nodev";
        # devices = [ "nodev" ];
        # useOSProber = true;
      };
    };
  };
}
