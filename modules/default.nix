{ config, pkgs, ... }:

{
  imports = [
    ./modules
    ./packages
  ];

  home.username = "mathod";
  home.homeDirectory = "/home/mathod";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
