{
  # Changement de contexte et de namespace Kubernetes (kubectx, kubens), réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.kubectx =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kubectx ];
    };
}
