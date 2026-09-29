{ inputs, ... }:
{
  # Active le registre des aspects: flake.modules.<classe>.<nom>
  imports = [ inputs.flake-parts.flakeModules.modules ];
}
