{
  # Remplaçant moderne de ls, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.eza =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.eza ];
    };
}
