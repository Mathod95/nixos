{
  # Client Plex, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.plex =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.plex-desktop ];
    };
}
