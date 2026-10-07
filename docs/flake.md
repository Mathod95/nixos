---
title: Flake
description: Architecture du flake, commandes utilisées pour le créer et pour l'utiliser
icon: material/snowflake
status: draft
createdAt: 2026-09-30
modifyAt: 2026-09-30
todo:
  - "[x] Tester le premier switch sur la workstation"
  - "[ ] Tester le premier switch sur le laptop et WSL"
---

# Flake

> Le squelette du flake: Son architecture de fichiers, son fonctionnement, les commandes utilisées pour le créer et celles pour l'appliquer sur une machine.

## Architecture

```text
.
├── flake.nix                          # inputs + import automatique de modules/ et hosts/
├── flake.lock                         # commit exact de chaque input
├── .sops.yaml                         # clé age utilisée pour chiffrer secrets/
├── secrets/
│   ├── age-key.txt.age                # clé age, chiffrée par passphrase
│   └── common.yaml                    # secrets chiffrés (sops)
├── modules/
│   ├── flake/
│   │   ├── systems.nix                # architectures supportées (x86_64-linux)
│   │   ├── modules.nix                # active le registre flake.modules
│   │   ├── formatter.nix              # nix fmt → nixfmt
│   │   └── bootstrap.nix              # nix run .#bootstrap: clé age + premier switch
│   ├── profiles/
│   │   ├── minimal.nix                # base commune à toutes les machines
│   │   ├── desktop.nix                # PC fixes: workstation, desktop
│   │   ├── laptop.nix                 # portables
│   │   └── wsl.nix                    # NixOS-WSL
│   ├── features/
│   │   ├── systemd-boot.nix           # bootloader UEFI
│   │   ├── networkmanager.nix         # réseau
│   │   ├── gaming.nix                 # Steam
│   │   ├── docker.nix                 # Docker
│   │   ├── sops.nix                   # secrets (sops-nix)
│   │   └── ssh.nix                    # serveur SSH + mDNS
│   ├── gui/
│   │   ├── gui.nix                    # base graphique commune (clavier, audio, impression)
│   │   └── gnome.nix                  # GDM + GNOME
│   ├── programs/                      # une application home-manager par dossier
│   │   ├── ghostty/
│   │   │   └── ghostty.nix            # terminal (profil gui)
│   │   ├── k9s/
│   │   │   └── k9s.nix                # outils console (profil minimal)
│   │   └── …                          # une par application (liste complète dans Packages)
│   └── users/
│       └── mathod.nix                 # utilisateur + home-manager
└── hosts/
    ├── workstation/
    │   ├── default.nix                # composition de la machine
    │   └── _hardware-configuration.nix
    ├── laptop/
    │   ├── default.nix
    │   └── _hardware-configuration.nix
    └── wsl/
        └── default.nix
```

## How it works

- **Import automatique**: `flake.nix` passe `modules/` et `hosts/` à [import-tree](https://github.com/vic/import-tree). Chaque fichier `.nix` y est un module [flake-parts](https://flake.parts/), importé sans avoir à l'ajouter dans une liste. Un fichier peut donc être déplacé ou renommé librement.
- **Les fichiers ignorés**: import-tree ignore tout chemin qui contient `/_`. C'est pour ça que les `hardware-configuration.nix` sont préfixés par `_`: Ce sont des modules NixOS classiques, pas des modules flake-parts, et ils sont importés à la main par leur machine.
- **Le registre des aspects**: Chaque profil ou fonctionnalité se déclare dans `flake.modules.nixos.<nom>` (ou `flake.modules.homeManager.<nom>`). Le registre est activé par `modules/flake/modules.nix`.
- **Les machines**: Chaque machine se déclare dans `flake.nixosConfigurations.<nom>` et liste les aspects qu'elle importe. Ses réglages propres (nom d'hôte, `stateVersion`, matériel) restent dans son `default.nix`.

``` { .nix .codeblock title="hosts/workstation/default.nix" }
{ inputs, ... }:
{
  flake.nixosConfigurations.workstation = inputs.nixpkgs.lib.nixosSystem {
    modules = with inputs.self.modules.nixos; [
      minimal
      gui
      gnome
      desktop
      mathod
      ./_hardware-configuration.nix
      {
        networking.hostName = "workstation";
        system.stateVersion = "26.05";
        home-manager.users.mathod.home.stateVersion = "26.05";
      }
    ];
  };
}
```

## Inputs

| Input          | Branch           | Role                                                |
| -------------- | ---------------- | --------------------------------------------------- |
| `nixpkgs`      | `nixos-unstable` | Paquets et modules NixOS                            |
| `flake-parts`  | `main`           | Structure du flake en modules, registre des aspects |
| `import-tree`  | `main`           | Import automatique des fichiers `.nix`              |
| `home-manager` | `master`         | Configuration utilisateur                           |
| `nixos-wsl`    | `main`           | Modules NixOS pour WSL                              |
| `sops-nix`     | `master`         | Déchiffrement des secrets sur les machines          |

Tous les inputs qui dépendent de nixpkgs le suivent avec `follows`. disko sera ajouté à l'étape Partitioning.

## Hosts

| Host          | Aspects                                                                  |
| ------------- | ------------------------------------------------------------------------ |
| `workstation` | `minimal` + `gui` + `gnome` + `desktop` + `gaming` + `docker` + `mathod` |
| `laptop`      | `minimal` + `gui` + `gnome` + `laptop` + `gaming` + `docker` + `mathod`  |
| `wsl`         | `minimal` + `wsl` + `mathod`                                             |

Les profils `desktop` et `laptop` importent pour l'instant les mêmes fonctionnalités (`systemd-boot`, `networkmanager`). Ils divergeront avec les réglages propres aux portables (batterie, veille…).

## Creation commands

Commandes utilisées, dans l'ordre, pour créer ce squelette depuis la racine du repo.

1. Créer l'arborescence et reprendre les `hardware-configuration.nix` générés par l'installeur:

    ``` { .console .codeblock }
    $ mkdir -p modules/flake modules/profiles modules/features modules/gui modules/users hosts/workstation hosts/laptop hosts/wsl
    $ cp .inbox/workstation/hardware-configuration.nix hosts/workstation/_hardware-configuration.nix
    $ cp .inbox/laptop/hardware-configuration.nix hosts/laptop/_hardware-configuration.nix
    $ printf 'result\nresult-*\n' >> .gitignore
    ```

2. Écrire `flake.nix` et les fichiers de `modules/` et `hosts/` (contenu dans le repo).

3. Ajouter les fichiers à l'index git. Un flake ne voit **que les fichiers suivis par git**: Un fichier non ajouté est invisible pour Nix, sans message d'erreur clair.

    ``` { .console .codeblock }
    $ git add flake.nix modules hosts .gitignore
    ```

4. Créer `flake.lock`, qui fixe le commit de chaque input:

    ``` { .console .codeblock }
    $ nix flake lock
    $ git add flake.lock
    ```

5. Vérifier que le flake et les trois machines s'évaluent, sans rien construire:

    ``` { .console .codeblock }
    $ nix flake check --no-build
    $ nix eval --raw .#nixosConfigurations.workstation.config.system.build.toplevel.drvPath
    ```

6. Formater tout le repo avec nixfmt:

    ``` { .console .codeblock }
    $ nix fmt
    ```

!!! info "Nix sans installation, via nix-portable"
    Le WSL Debian utilisé pour écrire ce squelette n'a pas Nix. Les commandes `nix` ci-dessus y ont été lancées avec [nix-portable](https://github.com/DavHau/nix-portable), un binaire autonome qui garde son store dans un dossier au choix, sans rien installer sur le système:

    ``` { .console .codeblock }
    $ NP_LOCATION=/tmp/nix-portable ./nix-portable nix flake lock
    $ NP_LOCATION=/tmp/nix-portable NP_RUNTIME=proot ./nix-portable nix fmt
    ```

    `NP_RUNTIME=proot` est nécessaire pour `nix fmt`, qui construit le formateur: Le runtime par défaut ne peut pas créer d'espace de noms isolé dans ce WSL. nix-portable embarque Nix 2.20, qui ne connaît pas la sortie `modules` du flake: `nix flake check` affiche un avertissement `unknown flake output 'modules'`, sans conséquence.

## Usage

**Première fois sur une machine**, installation fraîche ou machine qui n'a pas encore la clé age:

``` { .console .codeblock }
$ nix --extra-experimental-features 'nix-command flakes' run github:Mathod95/nixos#bootstrap -- <host>
```

La commande `bootstrap` est fournie par le flake (`modules/flake/bootstrap.nix`). Elle dépose la clé age sur la machine, en demandant sa passphrase, puis lance le premier switch. Le détail est dans [SSH](ssh.md#new-machine).

**Toutes les mises à jour suivantes**, avec nh:

``` { .console .codeblock }
$ nh os switch github:Mathod95/nixos --refresh
```

Depuis un clone local du repo: `nh os switch .`.

!!! info "Flakes on a fresh install"
    L'option `--extra-experimental-features 'nix-command flakes'` n'est nécessaire que sur une installation fraîche, où les flakes sont désactivés. La config les active ensuite de façon permanente (profil `minimal`).

!!! warning "First switch"
    - **Nom d'hôte**: Une machine fraîchement installée s'appelle encore `nixos`. Le nom de sa configuration est donc obligatoire (`-- workstation`), et le nom d'hôte change avec le switch.
    - **WSL**: L'utilisateur par défaut passe de `nixos` à `mathod`. NixOS-WSL demande pour ça une procédure spéciale (`nixos-rebuild boot`, pas `switch`, puis redémarrage de la distro), décrite dans la [documentation NixOS-WSL](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html). Le `bootstrap` ne la gère pas.

## Changes from the generated configuration

Écarts entre les `configuration.nix` générés par l'installeur et ce flake:

- **Supprimés**: Les commentaires de l'installeur, et `i18n.extraLocaleSettings`, redondant puisque toutes les valeurs étaient déjà `fr_FR.UTF-8` comme `i18n.defaultLocale`.
- **Ajoutés**: Les flakes activés dans `minimal`, et `programs.nix-ld.enable` sous WSL pour le serveur VS Code Remote.
- **Modifiés**:
    - les noms d'hôte `nixos` deviennent `workstation`, `laptop` et `wsl`;
    - l'utilisateur WSL passe de `nixos` à `mathod`, et l'import par channel `<nixos-wsl/modules>` est remplacé par l'input `nixos-wsl`;
    - le groupe `networkmanager` n'est ajouté à `mathod` que si NetworkManager est activé sur la machine;
    - les `hardware-configuration.nix` sont renommés avec un `_` et reformatés par nixfmt, sans changement de contenu.

## Sources

- [flake-parts](https://flake.parts/), et son module [`flake.modules`](https://flake.parts/options/flake-parts-modules.html)
- [import-tree](https://github.com/vic/import-tree)
- [NixOS-WSL: Change username](https://nix-community.github.io/NixOS-WSL/how-to/change-username.html)
- [nix-portable](https://github.com/DavHau/nix-portable)
