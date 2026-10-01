{
  # Moniteur de ressources, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.btop =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.btop ];
    };
}
