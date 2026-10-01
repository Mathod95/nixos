{
  # Remplaçant de cat avec coloration syntaxique, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.bat =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.bat ];
    };
}
