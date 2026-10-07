{
  # Client SSH: Config, clé publique, et lien vers la clé privée déchiffrée par sops
  flake.modules.homeManager.ssh =
    { config, ... }:
    {
      home.file.".ssh/config".source = ./config;
      home.file.".ssh/nixos.pub".source = ./nixos.pub;
      home.file.".ssh/nixos".source = config.lib.file.mkOutOfStoreSymlink "/run/secrets/ssh/nixos";
    };
}
