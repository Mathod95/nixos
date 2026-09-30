---
title: Packages
description: Inventaire de tout ce qui est installé sur les machines, et du fichier où chaque élément est configuré
icon: material/package-variant
status: draft
createdAt: 2026-09-30
modifyAt: 2026-09-30
todo: []
---

# Packages

> Tout ce que la configuration installe ou active sur les machines, avec le fichier où chaque élément est configuré et les machines qui en profitent.

Les machines d'un élément découlent des aspects qu'elles importent (voir [Flake](../flake.md#hosts)): `minimal` est sur toutes les machines, `gui` et `gnome` sur la workstation et le laptop, `desktop` sur la workstation, `laptop` sur le laptop, `wsl` sur WSL.

## Programs

| Package                                                       | Managed by   | Option            | File                                                                                                                               | Machines                 |
| ------------------------------------------------------------- | ------------ | ----------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------ |
| [nh](https://github.com/nix-community/nh)                     | NixOS        | `programs.nh`     | [`modules/profiles/minimal.nix`](https://github.com/Mathod95/nixos/blob/main/modules/profiles/minimal.nix)                         | workstation, laptop, wsl |
| [nix-ld](https://github.com/nix-community/nix-ld)             | NixOS        | `programs.nix-ld` | [`modules/profiles/wsl.nix`](https://github.com/Mathod95/nixos/blob/main/modules/profiles/wsl.nix)                                 | wsl                      |
| [home-manager](https://github.com/nix-community/home-manager) | NixOS        | `home-manager`    | [`modules/users/mathod.nix`](https://github.com/Mathod95/nixos/blob/main/modules/users/mathod.nix)                                 | workstation, laptop, wsl |
| [Ghostty](https://ghostty.org/)                               | home-manager | `home.packages`   | [`modules/programs/ghostty/ghostty.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/ghostty/ghostty.nix)         | workstation, laptop      |
| [Git](https://git-scm.com/)                                   | home-manager | `home.packages`   | [`modules/programs/git/git.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/git/git.nix)                         | workstation, laptop, wsl |
| [eza](https://github.com/eza-community/eza)                   | home-manager | `home.packages`   | [`modules/programs/eza/eza.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/eza/eza.nix)                         | workstation, laptop, wsl |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch)       | home-manager | `home.packages`   | [`modules/programs/fastfetch/fastfetch.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/fastfetch/fastfetch.nix) | workstation, laptop, wsl |
| [fd](https://github.com/sharkdp/fd)                           | home-manager | `home.packages`   | [`modules/programs/fd/fd.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/fd/fd.nix)                             | workstation, laptop, wsl |
| [fzf](https://github.com/junegunn/fzf)                        | home-manager | `home.packages`   | [`modules/programs/fzf/fzf.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/fzf/fzf.nix)                         | workstation, laptop, wsl |
| [Helm](https://helm.sh/)                                      | home-manager | `home.packages`   | [`modules/programs/helm/helm.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/helm/helm.nix)                     | workstation, laptop, wsl |
| [kubectl](https://kubernetes.io/docs/reference/kubectl/)      | home-manager | `home.packages`   | [`modules/programs/kubectl/kubectl.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/kubectl/kubectl.nix)         | workstation, laptop, wsl |
| [kubectx](https://github.com/ahmetb/kubectx)                  | home-manager | `home.packages`   | [`modules/programs/kubectx/kubectx.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/kubectx/kubectx.nix)         | workstation, laptop, wsl |
| [k9s](https://k9scli.io/)                                     | home-manager | `home.packages`   | [`modules/programs/k9s/k9s.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/k9s/k9s.nix)                         | workstation, laptop, wsl |
| [kubecolor](https://github.com/kubecolor/kubecolor)           | home-manager | `home.packages`   | [`modules/programs/kubecolor/kubecolor.nix`](https://github.com/Mathod95/nixos/blob/main/modules/programs/kubecolor/kubecolor.nix) | workstation, laptop, wsl |

## Desktop

| Package                                      | Managed by | Option                                | File                                                                                         | Machines            |
| -------------------------------------------- | ---------- | ------------------------------------- | -------------------------------------------------------------------------------------------- | ------------------- |
| [GNOME](https://www.gnome.org/)              | NixOS      | `services.desktopManager.gnome`       | [`modules/gui/gnome.nix`](https://github.com/Mathod95/nixos/blob/main/modules/gui/gnome.nix) | workstation, laptop |
| [GDM](https://gitlab.gnome.org/GNOME/gdm)    | NixOS      | `services.displayManager.gdm`         | [`modules/gui/gnome.nix`](https://github.com/Mathod95/nixos/blob/main/modules/gui/gnome.nix) | workstation, laptop |
| [PipeWire](https://pipewire.org/)            | NixOS      | `services.pipewire`, `security.rtkit` | [`modules/gui/gui.nix`](https://github.com/Mathod95/nixos/blob/main/modules/gui/gui.nix)     | workstation, laptop |
| [CUPS](https://openprinting.github.io/cups/) | NixOS      | `services.printing`                   | [`modules/gui/gui.nix`](https://github.com/Mathod95/nixos/blob/main/modules/gui/gui.nix)     | workstation, laptop |

## System

| Package                                                                         | Managed by | Option                      | File                                                                                                                     | Machines                 |
| ------------------------------------------------------------------------------- | ---------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------ | ------------------------ |
| [systemd-boot](https://www.freedesktop.org/wiki/Software/systemd/systemd-boot/) | NixOS      | `boot.loader.systemd-boot`  | [`modules/features/systemd-boot.nix`](https://github.com/Mathod95/nixos/blob/main/modules/features/systemd-boot.nix)     | workstation, laptop      |
| [NetworkManager](https://networkmanager.dev/)                                   | NixOS      | `networking.networkmanager` | [`modules/features/networkmanager.nix`](https://github.com/Mathod95/nixos/blob/main/modules/features/networkmanager.nix) | workstation, laptop      |
| [NixOS-WSL](https://github.com/nix-community/NixOS-WSL)                         | NixOS      | `wsl`                       | [`modules/profiles/wsl.nix`](https://github.com/Mathod95/nixos/blob/main/modules/profiles/wsl.nix)                       | wsl                      |
| Dédoublonnage du store                                                          | NixOS      | `nix.optimise`              | [`modules/profiles/minimal.nix`](https://github.com/Mathod95/nixos/blob/main/modules/profiles/minimal.nix)               | workstation, laptop, wsl |

Le fonctionnement de nh, du nettoyage et du dédoublonnage est détaillé dans [Generations](../generations.md).


## Default packages

Paquets et services installés automatiquement par un module, sans être listés dans la configuration. Ils sont gérés par NixOS, avec le module qui les apporte.

### GNOME

Installés par `services.desktopManager.gnome`, activé dans [`modules/gui/gnome.nix`](https://github.com/Mathod95/nixos/blob/main/modules/gui/gnome.nix), sur la workstation et le laptop. Le module est organisé en groupes:

| Group            | Option                                | Default   | Content                                                  |
| ---------------- | ------------------------------------- | --------- | -------------------------------------------------------- |
| Services système | `services.gnome.core-os-services`     | Activé    | Réseau, énergie, disques, trousseau de clés, indexation… |
| Shell            | `services.gnome.core-shell`           | Activé    | GNOME Shell, Paramètres, fonds d'écran, Bluetooth        |
| Applications     | `services.gnome.core-apps`            | Activé    | Les applications de base (tableau ci-dessous)            |
| Jeux             | `services.gnome.games`                | Désactivé | Sudoku, Mines, Chess, 2048, Mahjongg…                    |
| Outils de dev    | `services.gnome.core-developer-tools` | Désactivé | GNOME Builder, dconf-editor, Sysprof…                    |

#### Applications

| App                   | Package                | Role                                     |
| --------------------- | ---------------------- | ---------------------------------------- |
| Fichiers              | `nautilus`             | Gestionnaire de fichiers                 |
| Console               | `gnome-console`        | Terminal                                 |
| Web                   | `epiphany`             | Navigateur, le seul installé             |
| Éditeur de texte      | `gnome-text-editor`    | Éditeur de texte                         |
| Papers                | `papers`               | Lecteur de PDF                           |
| Loupe                 | `loupe`                | Visionneuse d'images                     |
| Showtime              | `showtime`             | Lecteur vidéo                            |
| Decibels              | `decibels`             | Lecteur audio                            |
| Musique               | `gnome-music`          | Bibliothèque musicale                    |
| Snapshot              | `snapshot`             | Appareil photo (webcam)                  |
| Calculatrice          | `gnome-calculator`     | Calculatrice                             |
| Agenda                | `gnome-calendar`       | Agenda                                   |
| Horloges              | `gnome-clocks`         | Horloges, alarmes, minuteur              |
| Météo                 | `gnome-weather`        | Météo                                    |
| Cartes                | `gnome-maps`           | Cartes                                   |
| Contacts              | `gnome-contacts`       | Contacts                                 |
| Caractères            | `gnome-characters`     | Caractères spéciaux et emojis            |
| Moniteur système      | `gnome-system-monitor` | Processus et ressources                  |
| Journaux              | `gnome-logs`           | Journaux système                         |
| Disques               | `gnome-disk-utility`   | Gestion des disques                      |
| Baobab                | `baobab`               | Analyse de l'espace disque               |
| Connexions            | `gnome-connections`    | Client de bureau à distance              |
| Numériseur            | `simple-scan`          | Numérisation                             |
| Mots de passe et clés | `seahorse`             | Trousseau de clés, clés SSH et GPG       |
| Polices               | `gnome-font-viewer`    | Aperçu des polices                       |
| Tecla                 | `gnome-tecla`          | Aperçu de la disposition du clavier      |
| Aide                  | `yelp`                 | Documentation GNOME                      |
| Sushi                 | `sushi`                | Aperçu rapide des fichiers dans Fichiers |

#### Shell and services

- **Shell**: `gnome-shell`, les Paramètres (`gnome-control-center`), les fonds d'écran, le Bluetooth, la gestion des couleurs, et la visite guidée du premier démarrage (`gnome-tour`).
- **Matériel et système**: NetworkManager, Bluetooth, gestion de l'énergie (`power-profiles-daemon`, `upower`), disques (`udisks2`), Thunderbolt (`bolt`).
- **Session**: Trousseau de clés (`gnome-keyring`), comptes en ligne, indexation des fichiers (`localsearch`, `tinysparql`), géolocalisation (`geoclue2`), partage et bureau à distance, lecteur d'écran (`orca`).
- **Agent SSH** (`gcr-ssh-agent`): Il peut garder en mémoire la passphrase des clés SSH pendant la session.

!!! tip "Remove what is not used"
    Une application par défaut se retire avec `environment.gnome.excludePackages`. Pour ne garder que le strict minimum, `services.gnome.core-apps.enable = false` retire tout le groupe Applications.

Source: [Module GNOME de NixOS](https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/gnome.nix).

