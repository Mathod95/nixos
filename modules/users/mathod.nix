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
        ++ lib.optional config.networking.networkmanager.enable "networkmanager";
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
