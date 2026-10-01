{
  # Messagerie Discord, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.discord ];
    };
}
