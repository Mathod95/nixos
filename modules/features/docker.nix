{
  # Docker est un service système: Il passe par le module NixOS.
  # L'utilisateur est ajouté au groupe docker dans modules/users/mathod.nix
  flake.modules.nixos.docker = {
    virtualisation.docker.enable = true;
  };
}
