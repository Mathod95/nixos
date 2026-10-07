{ inputs, ... }:
{
  # Secrets: Une seule clé age, déposée sur chaque machine à l'installation
  flake.modules.nixos.sops = {
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops = {
      defaultSopsFile = inputs.self + "/secrets/common.yaml";
      age.keyFile = "/var/lib/sops-nix/key.txt";
      # Les clés SSH d'hôte ne servent pas à déchiffrer
      age.sshKeyPaths = [ ];
      gnupg.sshKeyPaths = [ ];
    };
  };
}
