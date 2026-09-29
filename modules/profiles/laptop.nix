{ inputs, ... }:
{
  flake.modules.nixos.laptop.imports = with inputs.self.modules.nixos; [
    systemd-boot
    networkmanager
  ];
}
