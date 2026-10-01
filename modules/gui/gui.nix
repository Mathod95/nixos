{ inputs, ... }:
{
  # Base commune à toutes les machines graphiques, quel que soit le WM/DE
  flake.modules.nixos.gui = {
    services.xserver.xkb = {
      layout = "fr";
      variant = "";
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.printing.enable = true;

    # Applications graphiques, ajoutées à chaque utilisateur home-manager de la machine
    home-manager.sharedModules = with inputs.self.modules.homeManager; [
      ghostty
      vscode
      telegram
      discord
      spotify
      plex
    ];
  };
}
