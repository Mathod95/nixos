{
  # Serveur SSH (connexion par clé uniquement) et noms <machine>.local sur le réseau local
  flake.modules.nixos.ssh = {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };

    # mDNS: Chaque machine annonce <nom>.local et sait résoudre celui des autres
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
      };
    };
  };
}
