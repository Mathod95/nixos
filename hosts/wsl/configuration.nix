{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../core.nix
    ];

#  system.stateVersion = "25.11";

  # Mathod

  # Enable experimental features
#  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable the Zsh shell
#  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
#  users.users.mathod = {
#    isNormalUser = true;
#    extraGroups = [ "wheel" ];
#    shell = pkgs.zsh;
#  };

  # Enable WSL support
  wsl.enable = true;
  wsl.defaultUser = "mathod";

  # Allow unfree packages
#  nixpkgs.config.allowUnfree = true;

  # Enable the Visual Studio Code editor
  programs.nix-ld.enable = true;
}
