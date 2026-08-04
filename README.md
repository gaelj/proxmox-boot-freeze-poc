This is a proof-of-concept for issue [nixos/initrd.systemd: hangs boot of Proxmox guest VMs (randomly)](https://github.com/NixOS/nixpkgs/issues/539277)

## Usage

Add the flake to your inputs:

```nix
proxmox-poc = {
    url = "github:gaelj/proxmox-boot-freeze-poc";
    inputs.nixpkgs.follows = "nixpkgs";
};
```

Add the module `proxmox-poc.nixosModules.proxmox-poc` to your nixosConfiguration modules.

Add in your config `systemd.network.networks."10-proxmox-lan".matchConfig.Name = [ "<network interface>" ];` (requires `systemd-networkd` networking)

Generate the VM image with `nixos-rebuild build-image --image-variant proxmox --flake .#proxmox-poc`
Note the store path.
