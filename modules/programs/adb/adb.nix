{
  # adb et fastboot. Les droits d'accès aux appareils USB sont gérés par systemd,
  # l'ancien module NixOS programs.adb n'existe plus
  flake.modules.homeManager.adb =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.android-tools ];
    };
}
