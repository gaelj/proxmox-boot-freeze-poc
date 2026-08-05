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

  hostPrivateKeyPath = "/etc/age/key.txt";
  hostPublicKey = lib.strings.trim (lib.readFile (flakeRoot + "/resources/age/${hostName}.age.pub"));

  isValidUser = u: builtins.elem u (builtins.attrNames config.home-manager.users);

  secretAdminUsers = lib.filter isValidUser [
    "nixos"
  ];

  secretAdminMasterIdentities = map (username: {
    identity = "/home/${username}/.ssh/id_ed25519_agenix_${username}";
    pubkey = lib.strings.trim (
      lib.readFile (flakeMainDir + "/users/${username}/resources/age/id_ed25519_agenix_${username}.pub")
    );
  }) secretAdminUsers;

  secretAdminIdentityPaths = map (x: x.identity) secretAdminMasterIdentities;
in
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/virtualisation/proxmox-image.nix")
  ];

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

  system.stateVersion = "26.11";

  sharedConfig = {
    boot = {
      videoResolution = "";
      loader = "grub";
    };
    devices.kmscon.enable = false;
    network.interface = "ens18";
    flakeRoot = ./.;
    flakeMainDir = ./flake;
    stylixGlobal = {
      enable = lib.mkDefault true;
      theme = lib.mkDefault "catppuccin-mocha";
      polarity = lib.mkDefault "dark";
    };
  };

  # run `agenix update-masterkeys` after modifying this
  age = {
    # Path to SSH keys to be used as identities in age decryption.
    identityPaths = [ ]; # hostPrivateKeyPath ] ++ secretAdminIdentityPaths;
    rekey = {
      # age public key to use as a recipient when rekeying
      hostPubkey = hostPublicKey;
      # identities used to decrypt the stored secrets to rekey them
      masterIdentities = [
        {
          identity = hostPrivateKeyPath;
          pubkey = hostPublicKey;
        }
      ]
      # ++ secretAdminMasterIdentities
      ;
    };
  };

  proxmox.qemuConf.bios = "ovmf";

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
    # kernelParams = lib.mkForce [];

    loader = {
      # grub.enable = true;
      systemd-boot.enable = true;
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

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
