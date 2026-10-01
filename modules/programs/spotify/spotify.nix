{
  # Musique, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.spotify =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.spotify ];
    };
}
