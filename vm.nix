{
  pkgs,
  system,
  lib,
  ...
}:
{
  config = {
    services.proxmox-ve = {
      vms = {
        myvm1 = {
          vmid = 100;
          memory = 8192;
          cores = 4;
          sockets = 2;
          kvm = false;
          net = [
            {
              model = "virtio";
              bridge = "vmbr0";
            }
          ];
          scsi = [ { file = "local:16"; } ];
        };
      };
    };
  };
}
