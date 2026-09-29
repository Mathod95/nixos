{ inputs, ... }:
{
  # PC fixes: workstation et desktop
  flake.modules.nixos.desktop.imports = with inputs.self.modules.nixos; [
    systemd-boot
    networkmanager
  ];
}
