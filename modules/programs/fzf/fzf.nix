{
  # Recherche floue en ligne de commande, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.fzf =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.fzf ];
    };
}
