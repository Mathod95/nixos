{
  # Messagerie Telegram, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.telegram =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.telegram-desktop ];
    };
}
