{
  lib,
  pkgs,
  config,
  modulesPath,
  self',
  ...
}:
{
  proxmox.cloudInit.enable = false;

  sharedConfig = {
    boot = {
      videoResolution = "";
      loader = null;
    };
    devices.kmscon.enable = false;
  };

  boot = {
    initrd = {
      kernelModules = [ ];
      availableKernelModules = [
        "ata_piix"
        "uhci_hcd"
        "virtio_pci"
        "sr_mod"
        "virtio_blk"
      ];
    };

    kernelModules = [
    ];
    extraModulePackages = [ ];
    kernelParams = lib.mkForce [
      "console=ttyS0"
      "root=fstab"
      "loglevel=4"
      "lsm=landlock,yama,bpf"
    ];
    growPartition = lib.mkDefault true;
  };
}
