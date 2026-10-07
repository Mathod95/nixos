{ inputs, ... }:
{
  # nix run github:Mathod95/nixos#bootstrap -- <machine>
  # Vérifie que le repo décrit bien cette machine, dépose la clé age (une seule fois),
  # puis lance le switch.
  perSystem =
    { pkgs, lib, ... }:
    let
      # Disque racine attendu pour chaque machine du flake (vide sous WSL, qui n'en déclare pas)
      roots = lib.mapAttrs (
        _: c: if c.config.wsl.enable or false then "" else c.config.fileSystems."/".device or ""
      ) inputs.self.nixosConfigurations;
      hosts = lib.concatStringsSep ", " (lib.attrNames roots);
      cases = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: root: "  ${name}) root=${lib.escapeShellArg root} ;;") roots
      );
    in
    {
      packages.bootstrap = pkgs.writeShellApplication {
        name = "bootstrap";
        runtimeInputs = [ pkgs.age ];
        text = ''
          host="''${1:-$(cat /proc/sys/kernel/hostname)}"
          key=/var/lib/sops-nix/key.txt

          if [ "$host" = "nixos" ]; then
            echo "Cette machine s'appelle encore 'nixos': Précise sa configuration." >&2
            echo "Usage: bootstrap <machine>   (machines du flake: ${hosts})" >&2
            exit 1
          fi

          # 1. La machine est-elle déclarée dans le flake ?
          case "$host" in
          ${cases}
            *)
              echo "'$host' n'est pas déclarée dans le flake." >&2
              echo "Machines du flake: ${hosts}" >&2
              echo "Il faut d'abord créer hosts/$host/ dans le repo." >&2
              exit 1
              ;;
          esac

          # 2. Le disque décrit dans le repo est-il bien celui de cette machine ?
          if [ "''${root#/dev/}" != "$root" ] && [ ! -e "$root" ]; then
            echo "Le disque racine attendu pour '$host' n'existe pas sur cette machine:" >&2
            echo "  $root" >&2
            echo "Le hardware-configuration.nix du repo ne correspond pas à cette installation" >&2
            echo "(machine réinstallée, ou mauvais nom de machine). Rien n'a été modifié." >&2
            echo "Il faut d'abord mettre à jour hosts/$host/_hardware-configuration.nix dans le repo." >&2
            exit 1
          fi

          # 3. La clé age
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

          # 4. Le switch
          echo "Switch sur la configuration '$host'..."
          sudo nixos-rebuild switch --flake "${inputs.self}#$host"
        '';
      };
    };
}
