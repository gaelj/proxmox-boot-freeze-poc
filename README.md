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

Generate the VM image by running in this repo:
`nixos-rebuild build-image --image-variant proxmox --flake .#proxmox-poc`
Note the store path.

Apply the config.

Open proxmox in a browser at `https://localhost:8006/`. Use PAM creds with `root` and your system's root password.

```bash
# destroy any previous instance
sudo qm destroy 101

sudo pvesm set local --content iso,vztmpl,backup,images

sudo qmrestore /nix/store/zdvyindsv5d612cbkyk88li9nwiqaxlz-vzdump-qemu-nixos-26.11.20260804.418bb87/vzdump-qemu-nixos-26.11.20260804.418bb87.vma.zst 101 --storage local
```

Start the VM in proxmox.

Login with `nixos` / `nixos`.

Create `/etc/age/key.txt` with contents:

```
# created: 2026-08-04T20:41:07+02:00
# public key: age1fx3kjt7ayswcrll0yl8duz6hh0m5qwvglluen0c55k6mn52n2upqfu6cfk
AGE-SECRET-KEY-1HK4PDFJLYWQKHXQK6HG38YU3FTYFTXUN2RCVHUNQN3UKMJLNVJHQKEYD8Q
```
