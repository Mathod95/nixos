{ config, pkgs, ... }:

{
  imports = [
    ./home/fastfetch/fastfetch.nix
    ./home/zellij/zellij.nix
    ./home/zsh/zsh.nix
    ./packages/packages.nix
  ];

  home.username = "mathod";
  home.homeDirectory = "/home/mathod";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
