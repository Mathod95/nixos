# nixos

Configuration NixOS personnelle en Nix flakes. La documentation du projet est publiée sur [mathod95.github.io/nixos](https://mathod95.github.io/nixos/).

## Bootstrap

À lancer une fois par machine, sur une installation fraîche ou sur une machine qui n'a pas encore la clé age, en remplaçant `workstation` par le nom de la machine (`workstation`, `laptop`, `wsl`):

```bash
nix --extra-experimental-features 'nix-command flakes' run --refresh github:Mathod95/nixos#bootstrap -- workstation
```

C'est la seule commande à retenir, quel que soit l'état de la machine. Elle enchaîne trois étapes:

1. **Une vérification**: Le repo doit décrire cette machine telle qu'elle est. Sinon, la commande s'arrête avec un message qui dit ce qui manque, sans rien modifier.
2. **La clé age**: Elle demande la passphrase, déchiffre la clé et la dépose dans `/var/lib/sops-nix/key.txt`. C'est elle qui permet à la machine de déchiffrer les secrets, dont la clé SSH. Si la clé est déjà en place, l'étape est ignorée.
3. **Le switch** sur la configuration de la machine.

À savoir:

- **Nom de la machine**: Il est obligatoire sur une installation fraîche, qui s'appelle encore `nixos`. Sur une machine déjà nommée, il peut être omis.
- `--refresh` force Nix à récupérer le dernier commit, au lieu d'une version gardée en cache jusqu'à une heure.
- **Flakes**: L'option `--extra-experimental-features` n'est nécessaire que sur une installation fraîche. La configuration les active ensuite de façon permanente.
- **Mot de passe**: La configuration n'en définit aucun, celui créé à l'installation est conservé.
- **Redémarrer** ensuite, pour que le nom d'hôte et les groupes soient pris en compte partout.

### When the command stops

La commande refuse de continuer dans deux cas, pour ne jamais laisser une machine dans un état cassé:

- **Machine absente du flake** (une nouvelle machine): Il faut d'abord créer son dossier `hosts/<machine>/` dans le repo.
- **Disque différent de celui du repo** (machine réinstallée, ou mauvais nom): Il faut d'abord remplacer `hosts/<machine>/_hardware-configuration.nix` par celui de l'installation actuelle. Sans cette vérification, la machine ne redémarrerait pas après le switch.

Deux cas ne sont pas vérifiés:

- **Distro WSL neuve**: Le changement d'utilisateur `nixos` vers `mathod` demande la [procédure de NixOS-WSL](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html).
- **Utilisateur d'installation**: Il doit s'appeler `mathod`, pour conserver son mot de passe et l'accès à `sudo`.

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
