# Package: https://mynixos.com/nixpkgs/package/spotify
# Documentation: https://wiki.nixos.org/wiki/Spotify
{ pkgs, ... }:

{
  home.packages = [ pkgs.spotify ];
}