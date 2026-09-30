{
  # Gestion de versions
  flake.modules.homeManager.git =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.git ];
      xdg.configFile."git/config".source = ./config;
    };
}
