{
  # Navigateur, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.chrome =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.google-chrome ];
    };
}
