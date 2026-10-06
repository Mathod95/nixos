{ inputs, ... }:
{
  # Base commune à toutes les machines, WSL compris
  flake.modules.nixos.minimal = {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;

    # Nettoyage des générations: Garde les 5 plus récentes et celles des 7 derniers jours
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
    };

    # Dédoublonnage du store en arrière-plan
    nix.optimise.automatic = true;

    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "fr_FR.UTF-8";
    console.keyMap = "fr";

    # Outils console, ajoutés à chaque utilisateur home-manager de la machine
    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      git
      eza
      fastfetch
      fd
      fzf
      helm
      kubectl
      kubectx
      k9s
      kubecolor
      vim
      bat
      btop
      zellij
      adb
    ];
  };
}
