{ inputs, ... }:
{
  flake.modules.nixos.wsl = {
    imports = [ inputs.nixos-wsl.nixosModules.default ];

    wsl.enable = true;
    wsl.defaultUser = "mathod";

    # Nécessaire au serveur VS Code Remote
    programs.nix-ld.enable = true;

    # Rend la distro compatible avec Docker Desktop (à activer aussi côté Windows:
    # Settings > Resources > WSL Integration)
    wsl.docker-desktop.enable = true;
  };
}
