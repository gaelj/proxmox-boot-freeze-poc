{ lib, pkgs, config, modulesPath, ... }:
{
  # User account with sudo privileges
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos"; # Change this!
  };

  system.stateVersion = "26.11";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/proxmox-image.nix")
  ];

  proxmox.qemuConf.bios = "seabios";

  networking.networkmanager.enable = true;

  services.qemuGuest.enable = true;

  fileSystems."/" = {
    autoFormat = true;
    autoResize = true;
  };

  boot = {
    initrd = {
      systemd.enable = lib.mkForce true; # set this false to fix the issue
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
      # "kvm-intel"
    ];
    extraModulePackages = [ ];

    loader = {
      grub.enable = true;
      # systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      grub = {
        devices = [ "nodev" ];
        useOSProber = true;
      };
    };
    growPartition = lib.mkDefault true;
  };

  hardware = {
    enableAllHardware = lib.mkDefault true;
    graphics.enable = true;
  };
  # time.hardwareClockInLocalTime = false;
  # hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
