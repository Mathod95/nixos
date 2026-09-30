{
  # Terminal, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.ghostty ];
    };
}
