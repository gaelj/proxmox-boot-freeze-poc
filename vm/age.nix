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
}
