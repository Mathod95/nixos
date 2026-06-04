{ config, pkgs, ... }:

{
  imports = [
    ./modules/bat/bat.nix
    ./modules/btop/btop.nix
    ./modules/eza/eza.nix
    ./modules/fastfetch/fastfetch.nix
    #./modules/ghostty/ghostty.nix
    ./modules/git/git.nix
    #./packages/packages.nix
    ./modules/vim/vim.nix
    ./modules/vscode/vscode.nix
    ./modules/zellij/zellij.nix
    ./modules/zsh/zsh.nix
  ];

  home.username = "mathod";
  home.homeDirectory = "/home/mathod";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
