---
title: SSH
description: Une seule clé SSH pour se connecter d'une machine à l'autre, transportée chiffrée dans le repo avec sops et age
icon: material/key-variant
status: draft
createdAt: 2026-10-07
modifyAt: 2026-10-07
todo:
  - "[ ] Lancer le bootstrap sur la workstation et le laptop"
  - "[ ] Tester la connexion SSH entre les machines"
  - "[ ] Valider WSL en serveur SSH: Pare-feu Windows et nom `wsl.local`"
  - "[ ] Tester l'édition d'un secret avec sops"
---

# SSH

> Une seule clé SSH, nommée `nixos`, pour se connecter de n'importe quelle machine vers n'importe quelle autre. Sa clé privée voyage chiffrée dans le repo, avec sops et age.

## How it works

```text
REPO PUBLIC
  secrets/age-key.txt.age          ← la clé age, chiffrée par sa passphrase
  secrets/common.yaml              ← la clé SSH privée "nixos", chiffrée pour la clé age
  modules/programs/ssh/nixos.pub   ← la clé SSH publique, en clair
        │
        │ 1. Une fois par machine: La clé age est déchiffrée à la main (passphrase)
        ▼
MACHINE
  /var/lib/sops-nix/key.txt        ← clé age en clair, lisible uniquement par root
        │
        │ 2. À chaque démarrage et à chaque switch, automatiquement
        ▼
  /run/secrets/ssh/nixos           ← clé SSH privée, lisible uniquement par mathod
  ~/.ssh/nixos                     ← lien vers /run/secrets/ssh/nixos
  ~/.ssh/nixos.pub, ~/.ssh/config  ← déposés par home-manager
```

| Key                  | Location                                               | Protected by                                    | Role                                      |
| -------------------- | ------------------------------------------------------ | ----------------------------------------------- | ----------------------------------------- |
| Clé age              | `secrets/age-key.txt.age`, `/var/lib/sops-nix/key.txt` | Sa passphrase dans le repo, root sur la machine | Déchiffrer les secrets                    |
| Clé SSH `nixos`      | `secrets/common.yaml`, puis `/run/secrets/ssh/nixos`   | sops dans le repo, et sa propre passphrase      | Se connecter aux machines                 |
| Clé publique `nixos` | `modules/programs/ssh/nixos.pub`                       | Rien, elle est publique                         | Autoriser la connexion sur chaque machine |

La clé SSH privée garde sa passphrase à l'intérieur du secret: Elle est donc protégée deux fois.

## Files

| File                           | Role                                                                    |
| ------------------------------ | ----------------------------------------------------------------------- |
| `.sops.yaml`                   | Indique à sops avec quelle clé age chiffrer les fichiers de `secrets/`  |
| `secrets/age-key.txt.age`      | La clé age, chiffrée par passphrase                                     |
| `secrets/common.yaml`          | Les secrets chiffrés, dont `ssh/nixos`                                  |
| `modules/features/sops.nix`    | sops-nix: Fichier de secrets par défaut et emplacement de la clé age    |
| `modules/features/ssh.nix`     | Serveur SSH et mDNS                                                     |
| `modules/programs/ssh/ssh.nix` | Client SSH: Dépose `config`, `nixos.pub` et le lien vers la clé privée  |
| `modules/users/mathod.nix`     | Autorise la clé publique et déclare le secret `ssh/nixos` pour `mathod` |

Les aspects `sops` et `ssh` sont importés par le profil `minimal`: Ils sont sur toutes les machines.

## Server

``` { .nix .codeblock title="modules/features/ssh.nix" }
services.openssh = {
  enable = true;
  settings = {
    PasswordAuthentication = false;
    KbdInteractiveAuthentication = false;
    PermitRootLogin = "no";
  };
};
```

- **Connexion par clé uniquement**: Les mots de passe sont refusés.
- **Pas de connexion en root**: On se connecte en `mathod`, puis `sudo`.
- **Une seule clé autorisée**: `nixos.pub`, déclarée dans `users.users.mathod.openssh.authorizedKeys.keyFiles`.

## Names on the local network

Chaque machine annonce son nom sur le réseau local avec mDNS (Avahi), et sait résoudre celui des autres. `laptop.local` désigne le laptop sans aucune adresse à retenir ni à configurer.

``` { .nix .codeblock title="modules/features/ssh.nix" }
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;
  publish = {
    enable = true;
    addresses = true;
  };
};
```

mDNS ne fonctionne que sur le même réseau local. Pour joindre une machine depuis l'extérieur, il faudra autre chose (un VPN comme Tailscale, par exemple).

## Client

``` { .text .codeblock title="modules/programs/ssh/config" }
Host workstation laptop desktop wsl
    HostName %h.local
    User mathod
    IdentityFile ~/.ssh/nixos
    AddKeysToAgent yes
```

``` { .console .codeblock }
$ ssh laptop
```

- **`HostName %h.local`** ajoute `.local` au nom tapé: `ssh laptop` se connecte à `laptop.local`.
- **`IdentityFile ~/.ssh/nixos`** est nécessaire parce que la clé ne porte pas un nom par défaut (`id_ed25519`).
- Le fichier ne contient aucune adresse: Il reste en clair dans le repo.

## Passphrase and agent

La clé `nixos` a une passphrase. Un agent SSH la garde en mémoire pendant la session, pour ne la taper qu'une fois (`AddKeysToAgent yes`).

| Machine             | Agent                                                   |
| ------------------- | ------------------------------------------------------- |
| workstation, laptop | Celui de GNOME (`gcr-ssh-agent`), activé avec le bureau |
| wsl                 | `programs.ssh.startAgent = true`, dans le profil `wsl`  |

## Creation commands

Commandes utilisées pour créer les clés, dans un dossier temporaire supprimé à la fin. Les clés privées en clair n'en sortent jamais: Seuls des fichiers chiffrés ou publics rejoignent le repo.

``` { .console .codeblock }
$ nix shell nixpkgs#age nixpkgs#sops
$ umask 077
$ w=$(mktemp -d) && cd "$w" && mkdir secrets
$ age-keygen -o key.txt
$ age -p -o secrets/age-key.txt.age key.txt
$ sudo mkdir -p -m 700 /var/lib/sops-nix
$ sudo install -m 600 -o root -g root key.txt /var/lib/sops-nix/key.txt
$ ssh-keygen -t ed25519 -f nixos -C nixos
$ pub=$(age-keygen -y key.txt)
$ printf 'creation_rules:\n  - path_regex: secrets/.*\\.yaml$\n    age: %s\n' "$pub" > .sops.yaml
$ { echo "ssh:"; echo "  nixos: |"; sed 's/^/    /' nixos; } > secrets/common.yaml
$ sops -e -i secrets/common.yaml
$ SOPS_AGE_KEY_FILE=key.txt sops -d secrets/common.yaml | head -3
```

1. `age-keygen` crée la clé age, `age -p` en fait une copie chiffrée par passphrase.
2. La clé age est installée sur la machine courante, dans `/var/lib/sops-nix/key.txt`.
3. `ssh-keygen` crée la clé SSH `nixos`, avec sa passphrase.
4. `.sops.yaml` reçoit la clé publique age, puis `sops -e -i` chiffre le fichier qui contient la clé SSH privée.
5. La dernière commande vérifie que le secret se déchiffre.

## New machine

Une machine ne peut déchiffrer les secrets que si elle a la clé age. La commande `bootstrap` du flake la dépose, puis lance le switch:

``` { .console .codeblock }
$ nix --extra-experimental-features 'nix-command flakes' run github:Mathod95/nixos#bootstrap -- <host>
```

1. Elle déchiffre `secrets/age-key.txt.age`, en demandant la passphrase de la clé age.
2. Elle dépose la clé dans `/var/lib/sops-nix/key.txt`, lisible uniquement par root. Si la clé est déjà en place, l'étape est ignorée.
3. Elle lance `nixos-rebuild switch` sur la configuration de la machine.

C'est la seule étape manuelle: Aucune automatisation ne peut taper la passphrase à la place de son propriétaire. Elle ne se fait qu'une fois par machine. Sans la clé, un switch signale une erreur de sops et la clé SSH n'est pas déposée, mais le reste du système est appliqué.

Après le switch, la clé SSH doit être en place:

``` { .console .codeblock }
$ sudo ls -l /run/secrets/ssh/nixos
$ ssh-keygen -y -f ~/.ssh/nixos
```

La seconde commande demande la passphrase de la clé SSH et affiche sa clé publique, qui doit être celle de `~/.ssh/nixos.pub`.

## Editing secrets

sops lit la copie de la clé age présente sur la machine:

``` { .console .codeblock }
$ SOPS_AGE_KEY_CMD="sudo cat /var/lib/sops-nix/key.txt" sops secrets/common.yaml
```

Le fichier s'ouvre déchiffré dans l'éditeur, et sops le rechiffre à l'enregistrement. Un nouveau secret se déclare ensuite dans la configuration avec `sops.secrets."<nom>"`.

## WSL

!!! warning "To validate"
    WSL est client et serveur SSH, comme les autres machines. Mais ce n'est pas une machine à part sur le réseau: En mode `networkingMode=mirrored`, il partage l'adresse de Windows. Trois points restent à valider:

    - **Le pare-feu Windows** bloque par défaut les connexions entrantes vers WSL.
    - **Le nom `wsl.local`**: Windows peut ne pas laisser WSL l'annoncer. WSL se joindrait alors par le nom du PC Windows.
    - **WSL ne répond que si Windows est allumé et la distro démarrée.**

## Sources

- [sops-nix](https://github.com/Mic92/sops-nix)
- [sops: age](https://getsops.io/docs/usage/identities/age/)
- [SSH, wiki NixOS](https://wiki.nixos.org/wiki/SSH)
