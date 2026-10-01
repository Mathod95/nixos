{
  # Éditeur de code, réglages par défaut (pas de fichier de config)
  flake.modules.homeManager.vscode =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.vscode ];
    };
}
