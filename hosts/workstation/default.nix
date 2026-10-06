{ inputs, ... }:
{
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [
      minimal
      gui
      gnome
      desktop
      gaming
      docker
      mathod
      ./_hardware-configuration.nix
      {
        networking.hostName = "workstation";
        system.stateVersion = "26.05";
        home-manager.users.mathod.home.stateVersion = "26.05";
      }
    ];
  };
}
