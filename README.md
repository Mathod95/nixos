# nixos

Configuration NixOS personnelle en Nix flakes. La documentation du projet est publiée sur [mathod95.github.io/nixos](https://mathod95.github.io/nixos/).

## Bootstrap

À lancer une fois par machine, sur une installation fraîche ou sur une machine qui n'a pas encore la clé age, en remplaçant `workstation` par le nom de la machine (`workstation`, `laptop`, `wsl`):

```bash
nix --extra-experimental-features 'nix-command flakes' run github:Mathod95/nixos#bootstrap -- workstation
```

La commande enchaîne deux étapes:

1. **La clé age**: Elle demande la passphrase, déchiffre la clé et la dépose dans `/var/lib/sops-nix/key.txt`. C'est elle qui permet à la machine de déchiffrer les secrets, dont la clé SSH. Si la clé est déjà en place, l'étape est ignorée.
2. **Le premier switch** sur la configuration de la machine.

À savoir:

- **Nom de la machine**: Il est obligatoire sur une installation fraîche, qui s'appelle encore `nixos`. Sur une machine déjà nommée, il peut être omis.
- **Flakes**: L'option `--extra-experimental-features` n'est nécessaire que sur une installation fraîche. La configuration les active ensuite de façon permanente.
- **Mot de passe**: La configuration n'en définit aucun, celui créé à l'installation est conservé.
- **Redémarrer** ensuite, pour que le nom d'hôte et les groupes soient pris en compte partout.

## Updates

Toutes les mises à jour suivantes se font avec [nh](https://github.com/nix-community/nh), installé par le bootstrap. Il affiche l'arbre de construction et le diff des paquets avant d'activer.

```bash
nh os switch github:Mathod95/nixos --refresh
```

- **Pas de `sudo`**: nh refuse de tourner en root et demande lui-même les droits quand il en a besoin.
- **Pas de nom de machine**: nh choisit par défaut la configuration qui porte le nom d'hôte de la machine. `-H workstation` permet de le préciser.
- `--refresh` force Nix à récupérer le dernier commit, au lieu d'une version gardée en cache jusqu'à une heure.
- `--ask` demande une confirmation avant d'activer.

Depuis un clone local du repo:

```bash
nh os switch .
```

## Rollback

Choisir la génération précédente dans le menu de démarrage, ou:

```bash
sudo nixos-rebuild switch --rollback
```
