{
  # Éditeur de texte, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.vim =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vim ];
    };
}
