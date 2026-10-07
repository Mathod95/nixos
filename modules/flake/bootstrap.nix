{ inputs, ... }:
{
  # nix run github:Mathod95/nixos#bootstrap -- <machine>
  # Dépose la clé age sur la machine (une seule fois), puis lance le switch.
  perSystem =
    { pkgs, ... }:
    {
      packages.bootstrap = pkgs.writeShellApplication {
        name = "bootstrap";
        runtimeInputs = [ pkgs.age ];
        text = ''
          host="''${1:-$(cat /proc/sys/kernel/hostname)}"
          key=/var/lib/sops-nix/key.txt

          if [ "$host" = "nixos" ]; then
            echo "Cette machine s'appelle encore 'nixos': Précise sa configuration." >&2
            echo "Usage: bootstrap <machine>" >&2
            exit 1
          fi

          if sudo test -s "$key"; then
            echo "Clé age déjà en place, étape ignorée."
          else
            echo "Déchiffrement de la clé age (passphrase demandée)..."
            tmp=$(mktemp -d)
            trap 'rm -rf "$tmp"' EXIT
            age -d -o "$tmp/key.txt" ${inputs.self + "/secrets/age-key.txt.age"}
            sudo install -D -m 600 -o root -g root "$tmp/key.txt" "$key"
            echo "Clé age déposée dans $key."
          fi

          echo "Switch sur la configuration '$host'..."
          sudo nixos-rebuild switch --flake "${inputs.self}#$host"
        '';
      };
    };
}
