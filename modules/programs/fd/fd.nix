{
  # Remplaçant moderne de find, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.fd =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.fd ];
    };
}
