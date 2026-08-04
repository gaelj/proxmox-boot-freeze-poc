{ lib, pkgs, config, modulesPath, ... }:
{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # User account with sudo privileges
  users.users.me = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos"; # Change this!
  };

  system.stateVersion = "26.11";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/proxmox-image.nix")
  ];

  proxmox.qemuConf.bios = "SeaBIOS";

  networking.networkmanager.enable = true;

  services = {
    qemuGuest.enable = lib.mkDefault true;
  };

  fileSystems."/" = {
    autoFormat = true;
    autoResize = true;
    # device = "/dev/disk/by-label/nixos";
    # enable = true;
    # formatOptions = null;
    # fsType = "ext4";
    # # label = null;
    # mountPoint = "/";
    # options = [
    #   "x-initrd.mount"
    #   "noatime
    # ];
  };

  boot = {
    initrd = {
      systemd.enable = lib.mkForce true; # set this false to fix the issue
      kernelModules = [ ];
      availableKernelModules = [
        "uhci_hcd"
        # "ehci_pci"
        # "ahci"
        "virtio_pci"
        "virtio_scsi"
        "sd_mod"
        "sr_mod"
        "ata_piix"
      ];
    };

    kernelModules = [
      # "kvm-intel"
    ];
    extraModulePackages = [ ];
    loader.grub = {
      device = lib.mkDefault "/dev/sda";
      devices = [ "nodev" ];
      useOSProber = true;
    };
    growPartition = lib.mkDefault true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    # layout = "be";
    variant = "";
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
