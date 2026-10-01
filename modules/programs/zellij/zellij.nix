{
  # Multiplexeur de terminal, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.zellij =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.zellij ];
    };
}
