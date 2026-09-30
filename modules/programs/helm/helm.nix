{
  # Gestionnaire de paquets Kubernetes, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.helm =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kubernetes-helm ];
    };
}
