{
  flake.modules.nixos.systemd-boot = {
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Limite le nombre d'entrées dans le menu de démarrage (et la place prise sur /boot)
    boot.loader.systemd-boot.configurationLimit = 10;
  };
}
