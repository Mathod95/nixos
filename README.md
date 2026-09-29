# nixos

Configuration NixOS personnelle en Nix flakes. La documentation du projet est publiée sur [mathod95.github.io/nixos](https://mathod95.github.io/nixos/).

## Apply the configuration

Depuis GitHub, sans cloner le repo, en remplaçant `workstation` par le nom de la machine (`workstation`, `laptop`, `wsl`):

```bash
sudo nixos-rebuild switch --flake github:Mathod95/nixos#workstation --refresh
```

- `#workstation` choisit la configuration de la machine.
- `--refresh` force Nix à récupérer le dernier commit, au lieu d'une version gardée en cache jusqu'à une heure.

Depuis un clone local du repo:

```bash
sudo nixos-rebuild switch --flake .#workstation
```

## First switch on a fresh install

- **Flakes**: `nixos-rebuild --flake` active lui-même les flakes pour sa commande. Si l'erreur `experimental Nix feature 'flakes' is disabled` apparaît malgré tout, ajouter `--option experimental-features 'nix-command flakes'`. La configuration les active ensuite de façon permanente.
- **Nom d'hôte**: Une machine fraîchement installée s'appelle `nixos`. Le nom de la machine est donc obligatoire dans la commande (`#workstation`), et le nom d'hôte change avec le switch. Redémarrer ensuite pour qu'il soit pris en compte partout, puis vérifier avec `hostname` et `nixos-version`.
- **Mot de passe**: La configuration n'en définit aucun, celui créé à l'installation est conservé.

## Rollback

Choisir la génération précédente dans le menu de démarrage, ou:

```bash
sudo nixos-rebuild switch --rollback
```
