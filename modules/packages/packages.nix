{ pkgs, ... }:

{
  home.packages = [
    pkgs.bambu-studio # https://mynixos.com/nixpkgs/package/bambu-studio
    pkgs.spotify      # https://mynixos.com/nixpkgs/package/spotify | https://wiki.nixos.org/wiki/Spotify
    pkgs.discord      # https://mynixos.com/nixpkgs/package/discord | https://wiki.nixos.org/wiki/Discord
    pkgs.bat
    pkgs.btop
    pkgs.eza
    pkgs.ghostty
    pkgs.git
    pkgs.vim
    pkgs.vscode
  ];
}

