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

Add in your config `networking.bridges."vmbr0".interfaces = [ "<network interface>" ];` (requires `NetworkManager` networking)

Generate the VM image with `nixos-rebuild build-image --image-variant proxmox --flake .#proxmox-poc`
Note the store path.

Apply the config.

Open proxmox in a browser at `https://localhost:8006/`. Use PAM creds with `root` and your system's root password.

```bash
sudo pvesm set local --content iso,vztmpl,backup,images

sudo qmrestore /nix/store/ydv79c1qd8hj5jk9xv1hgnpz3gi3pphz-vzdump-qemu-nixos-26.11.20260804.e72e4f2/vzdump-qemu-nixos-26.11.20260804.e72e4f2.vma.zst 101 --storage local
```

Start the VM in proxmox.
