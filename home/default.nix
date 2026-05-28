{ config, pkgs, ... }:

{
  imports = [
    ./git/git.nix
    #./vscode/vscode.nix
    ./spotify/spotify.nix
    ./vim/vim.nix
    ./fastfetch/fastfetch.nix
    ./btop/btop.nix
    ./bat/bat.nix
    ./eza/eza.nix
    ./zellij/zellij.nix
    ./ghostty/ghostty.nix
  ];

  home.username = "mathod";
  home.homeDirectory = "/home/mathod";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
