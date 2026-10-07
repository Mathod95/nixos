{
  # Édition des fichiers de secrets
  flake.modules.homeManager.sops =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.sops ];
    };
}
