{
  # `nix fmt` formate tout le repo avec nixfmt (style officiel, RFC 166)
  perSystem =
    { pkgs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
