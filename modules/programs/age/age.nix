{
  # Chiffrement, sert à déposer la clé age sur une machine
  flake.modules.homeManager.age =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.age ];
    };
}
