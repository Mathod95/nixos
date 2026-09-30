---
title: Generations
description: Conservation et nettoyage automatique des générations, du store Nix et du menu de démarrage
icon: material/history
status: draft
createdAt: 2026-09-30
modifyAt: 2026-09-30
todo: []
---

# Generations

> Comment les générations sont conservées puis supprimées automatiquement, et comment le store Nix est nettoyé et dédoublonné.

## How it works

- **Chaque switch crée une génération**: Une photo complète du système, qui reste disponible dans le menu de démarrage. C'est ce qui permet de revenir en arrière.
- **Supprimer une génération ne libère pas encore de place.** Il faut ensuite un **garbage collect**, qui efface du store (`/nix/store`) tous les paquets que plus aucune génération n'utilise.
- **Sans nettoyage**, les générations s'accumulent et le disque se remplit, ainsi que la partition `/boot`, qui garde un noyau par entrée de démarrage.

## Cleanup

Le nettoyage est confié à [nh](https://github.com/nix-community/nh), activé dans le profil `minimal`:

``` { .nix .codeblock title="modules/profiles/minimal.nix" }
programs.nh = {
  enable = true;
  clean.enable = true;
  clean.extraArgs = "--keep-since 7d --keep 5";
};
```

Une fois par semaine, le timer `nh-clean` lance `nh clean all --keep-since 7d --keep 5`, qui supprime les générations en trop puis lance le garbage collect. Les deux règles sont des **minimums**: Une génération n'est supprimée que si elle est **à la fois** hors des 5 plus récentes **et** vieille de plus de 7 jours.

- **Les 5 générations les plus récentes sont toujours gardées**, quel que soit leur âge.
- **Toutes celles des 7 derniers jours sont gardées aussi**, même s'il y en a plus de 5.

| Situation                                  | Result                                         |
| ------------------------------------------ | ---------------------------------------------- |
| 12 générations, dont 3 de moins de 7 jours | Les 5 plus récentes sont gardées, 7 supprimées |
| 8 générations, toutes de moins de 7 jours  | Les 8 sont gardées                             |

!!! info "Why nh rather than nix.gc"
    NixOS propose aussi `nix.gc.automatic`, qui ne raisonne qu'en âge (par exemple `--delete-older-than 14d`). Une machine restée un mois sans switch perdrait alors toutes ses anciennes générations, et avec elles toute possibilité de rollback. `nh clean` garde toujours un nombre minimum de générations. Les deux ne doivent pas être activés en même temps.

## Boot menu

``` { .nix .codeblock title="modules/features/systemd-boot.nix" }
boot.loader.systemd-boot.configurationLimit = 10;
```

Le menu de démarrage n'affiche que les 10 générations les plus récentes. Chaque entrée garde une copie du noyau et de l'initrd sur `/boot`: Sans limite, cette petite partition finit par se remplir. Les générations plus anciennes restent sur le disque tant que nh ne les a pas supprimées, mais elles ne sont plus proposées au démarrage.

## Store deduplication

Beaucoup de fichiers du store sont identiques d'un paquet à l'autre, ou d'une génération à l'autre. Le dédoublonnage les remplace par des liens vers un seul exemplaire.

!!! info "Two ways to deduplicate the store"
    - **`nix.optimise.automatic = true`**: Un service passe régulièrement sur tout le store, en arrière-plan. Par défaut, tous les jours à 3h45 (avec un décalage aléatoire de 30 minutes au plus), et au démarrage suivant si la machine était éteinte à cette heure-là.
    - **`nix.settings.auto-optimise-store = true`**: Le dédoublonnage se fait pendant chaque construction, au fur et à mesure. Le store est toujours optimisé, mais tous les builds et switchs sont un peu plus lents.

    nh sait aussi le faire: `nh clean` accepte une option `--optimise`, qui dédoublonne le store après le garbage collect.

    !!! success "Decision"
        **`nix.optimise.automatic = true`** est retenu, dans le profil `minimal`. Le dédoublonnage se fait quand la machine ne sert pas, sans ralentir les builds ni les switchs.

## Useful commands

| Command                                       | Role                                                           |
| --------------------------------------------- | -------------------------------------------------------------- |
| `nixos-rebuild list-generations`              | Lister les générations du système                              |
| `nh clean all --keep-since 7d --keep 5 -n`    | Afficher ce que le nettoyage supprimerait, sans rien supprimer |
| `nh clean all --keep-since 7d --keep 5`       | Lancer le nettoyage à la main                                  |
| `systemctl list-timers nh-clean nix-optimise` | Voir le prochain passage de chaque nettoyage                   |
| `nix store optimise`                          | Lancer le dédoublonnage à la main                              |

## Sources

- [nh](https://github.com/nix-community/nh)
- [Cleaning the Nix Store, manuel NixOS](https://nixos.org/manual/nixos/stable/#sec-nix-gc)
- [Options `nix.optimise` et `nix.settings.auto-optimise-store`](https://search.nixos.org/options?query=nix.optimise)
