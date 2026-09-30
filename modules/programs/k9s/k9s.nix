{
  # Interface terminal pour Kubernetes, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.k9s =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.k9s ];
    };
}
