{ inputs, ... }:
{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [
      minimal
      gui
      gnome
      laptop
      mathod
      ./_hardware-configuration.nix
      {
        networking.hostName = "laptop";
        system.stateVersion = "26.05";
        home-manager.users.mathod.home.stateVersion = "26.05";
      }
    ];
  };
}
