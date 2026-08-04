{
  pkgs,
  system,
  lib,
  ...
}:
{
  config = {
    # Make vmbr0 bridge visible in Proxmox web interface
    services.proxmox-ve.bridges = [ "vmbr0" ];

    networking = {
      # useNetworkd = false; # make sure you're not also toggling this on elsewhere
      # networkmanager.enable = lib.mkForce false; # disable NM, it's fighting you

      # useDHCP = lib.mkDefault true;

      # bridges."vmbr0".interfaces = [ "enp3s0" ];

      interfaces = {
        "vmbr0".useDHCP = lib.mkDefault true;
      };
    };
  };
}
