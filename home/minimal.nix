{ config, pkgs, ... }:

{
  imports = [
    ./zsh/zsh.nix
    ./fastfetch/fastfetch.nix
  ];

  home.username = "mathod";
  home.homeDirectory = "/home/mathod";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
