{ config, pkgs, ... }:

{
  imports = [
    ./bat/bat.nix
    ./btop/btop.nix
    ./eza/eza.nix
    ./fastfetch/fastfetch.nix
    ./ghostty/ghostty.nix
    ./git/git.nix
    ./packages/spotify.nix
    ./vim/vim.nix
    #./vscode/vscode.nix
    ./zellij/zellij.nix
    ./zsh/zsh.nix
  ];

  home.username = "mathod";
  home.homeDirectory = "/home/mathod";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
