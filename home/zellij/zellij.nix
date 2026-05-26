# Documentation: https://mynixos.com/home-manager/options/programs.zellij
# Configuration référence: https://zellij.dev/documentation
# GitHub: https://github.com/zellij-org/zellij
{ ... }:

{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    exitShellOnExit = true; # ferme le terminal quand tu quittes zellij
  };

  xdg.configFile."zellij/config.kdl".source = ./config.kdl;
}