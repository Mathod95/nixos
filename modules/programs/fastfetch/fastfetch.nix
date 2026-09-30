{
  # Informations système au lancement du terminal, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.fastfetch =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.fastfetch ];
    };
}
