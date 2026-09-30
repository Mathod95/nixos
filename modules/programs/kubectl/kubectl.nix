{
  # CLI Kubernetes, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.kubectl =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.kubectl ];
    };
}
