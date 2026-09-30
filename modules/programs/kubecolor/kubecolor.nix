{
  # Sortie de kubectl en couleur, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.kubecolor =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kubecolor ];
    };
}
