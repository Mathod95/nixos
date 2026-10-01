{
  # Steam passe par le module NixOS: Pilotes graphiques et audio 32 bits,
  # règles udev des manettes, ce que home-manager ne peut pas faire
  flake.modules.nixos.gaming = {
    programs.steam.enable = true;
  };
}
