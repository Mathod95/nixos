{ inputs, ... }:
{
  flake.nixosConfigurations.wsl = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [
      minimal
      wsl
      mathod
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        networking.hostName = "wsl";
        system.stateVersion = "26.05";
        home-manager.users.mathod.home.stateVersion = "26.05";
      }
    ];
  };
}
