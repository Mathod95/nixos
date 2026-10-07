{ inputs, ... }:
{
  flake.modules.nixos.mathod =
    { config, lib, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      users.users.mathod = {
        isNormalUser = true;
        description = "mathod";
        extraGroups = [
          "wheel"
        ]
        ++ lib.optional config.networking.networkmanager.enable "networkmanager"
        ++ lib.optional config.virtualisation.docker.enable "docker";
        # La clé "nixos" ouvre la connexion SSH depuis n'importe quelle machine
        openssh.authorizedKeys.keyFiles = [ ../programs/ssh/nixos.pub ];
      };

      # Clé privée SSH "nixos", déchiffrée par sops dans /run/secrets/ssh/nixos
      sops.secrets."ssh/nixos" = {
        owner = "mathod";
        mode = "0600";
      };

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak";
        users.mathod.imports = [ inputs.self.modules.homeManager.mathod ];
      };
    };

  # Configuration home-manager de mathod, vide pour l'instant
  flake.modules.homeManager.mathod = { };
}
