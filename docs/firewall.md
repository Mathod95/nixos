---
title: Firewall
description: Le pare-feu de NixOS, le blocage rencontré avec adb et Docker, et pourquoi il est désactivé
icon: material/wall-fire
status: draft
createdAt: 2026-10-07
modifyAt: 2026-10-07
todo:
  - "[ ] Valider que les téléphones apparaissent depuis le conteneur local et depuis l'autre PC"
---

# Firewall

> Le pare-feu de NixOS est activé par défaut. Il a bloqué l'accès à adb depuis des conteneurs Docker, et il est maintenant désactivé sur toutes les machines.

## Default behavior

Sans aucune ligne de configuration, NixOS active un pare-feu (`networking.firewall.enable = true`):

- **Tout ce qui entre est bloqué**, sauf les ports explicitement ouverts.
- **Tout ce qui sort est autorisé.**

Avant sa désactivation, voici ce qui était ouvert sur chaque machine:

| Opening          | Why                                                           |
| ---------------- | ------------------------------------------------------------- |
| Port TCP 22      | Le serveur SSH, ouvert automatiquement par `services.openssh` |
| Port UDP 5353    | mDNS, pour les noms en `.local` (Avahi)                       |
| Le ping          | Autorisé par défaut                                           |
| L'interface `lo` | La machine qui se parle à elle-même (`localhost`)             |

Les ports publiés par Docker (`docker run -p 8080:80`) font exception: Docker ajoute ses propres règles, qui passent à côté du pare-feu de NixOS.

## The case encountered

Le projet farmland pilote des téléphones Android à distance avec adb, depuis une interface web. Il a deux besoins:

| Flow                                                                | Path                         |
| ------------------------------------------------------------------- | ---------------------------- |
| Le conteneur local (interface sur le port 8080) → adb de la machine | Interface Docker → port 5037 |
| Un conteneur sur un autre PC → adb de cette machine                 | Réseau local → port 5037     |

Le serveur adb tourne directement sur la machine où les téléphones sont branchés, et le conteneur le joint avec `ADB_SERVER_SOCKET=tcp:host.docker.internal:5037`.

### Symptom

L'interface web n'affichait aucun téléphone, sans message d'erreur. Depuis le conteneur, la commande adb restait bloquée indéfiniment:

``` { .console .codeblock }
$ docker compose exec farmland sh -c 'adb -H host.docker.internal -P 5037 devices -l'
```

### Diagnosis

Chaque vérification a écarté une cause, jusqu'à ne laisser que le pare-feu:

``` { .console .codeblock title="Sur la machine: adb écoute bien, sur toutes les interfaces" }
$ ss -tlnp | grep 5037
LISTEN 0      4                  *:5037            *:*    users:(("adb",pid=44779,fd=6))
```

``` { .console .codeblock title="Dans le conteneur: le nom de la machine est bien résolu" }
$ docker compose exec farmland sh -c 'getent hosts host.docker.internal'
172.17.0.1      host.docker.internal
```

``` { .console .codeblock title="Dans le conteneur: l'application a bien la bonne variable" }
$ docker compose exec farmland sh -c 'cat /proc/1/environ | tr "\0" "\n" | grep ADB_SERVER_SOCKET'
ADB_SERVER_SOCKET=tcp:host.docker.internal:5037
```

``` { .console .codeblock title="La connexion reste en attente: code retour 124" }
$ timeout 5 docker compose exec farmland sh -c 'adb -H host.docker.internal -P 5037 devices -l'; echo "code retour: $?"
```

### Cause

Vu de la machine, un conteneur n'arrive pas par `localhost`: Il arrive par une interface réseau de Docker (`docker0`, ou `br-…` pour un réseau créé par `docker compose`). Le port 5037 n'étant pas ouvert, le pare-feu **ignore** les paquets au lieu de les refuser. C'est pour ça que la connexion reste en attente, sans erreur: Un port fermé sans pare-feu répondrait tout de suite "connexion refusée".

Le second flux, depuis un autre PC, est bloqué pour la même raison: Le port 5037 n'est pas ouvert au réseau local.

## Options

| Option                                                         | Container → machine | Other PC → machine       | adb protected from the network       |
| -------------------------------------------------------------- | ------------------- | ------------------------ | ------------------------------------ |
| Faire confiance aux interfaces Docker (`trustedInterfaces`)    | Débloqué            | Toujours bloqué          | Oui                                  |
| En plus, ouvrir le port 5037 au réseau, ou à une seule adresse | Débloqué            | Débloqué                 | Non, ou seulement pour cette adresse |
| Un tunnel SSH entre les deux PC                                | Débloqué            | Débloqué, trafic chiffré | Oui                                  |
| Désactiver le pare-feu                                         | Débloqué            | Débloqué                 | Non                                  |

!!! success "Decision"
    **Le pare-feu est désactivé sur toutes les machines**, dans le profil `minimal`. Plus aucun service n'est bloqué en entrée, quel que soit le projet.

    ``` { .nix .codeblock title="modules/profiles/minimal.nix" }
    networking.firewall.enable = false;
    ```

!!! danger "What it means"
    - **adb n'a aucune authentification.** Tant que son serveur écoute sur toutes les interfaces (`*:5037`), n'importe quel appareil du même réseau peut piloter les téléphones branchés: Installer des applications, lire leurs données, lancer des commandes.
    - **Tout service lancé sur une machine est joignable depuis le réseau où elle se trouve**, sans autre protection que la sienne. Pour le laptop, ça vaut aussi sur un wifi public.
    - Le serveur SSH reste protégé par lui-même: Il n'accepte que la clé `nixos`.

## If the firewall comes back

Pour réactiver le pare-feu sans retrouver le blocage, il faudra au minimum faire confiance aux interfaces Docker. Le `+` sert de joker pour toutes les interfaces dont le nom commence par `br-`:

``` { .nix .codeblock title="modules/features/docker.nix" }
networking.firewall.trustedInterfaces = [ "docker0" "br-+" ];
```

Et, pour l'autre PC, ouvrir le port 5037 ou passer par un tunnel SSH.

## Useful commands

| Command                        | Role                                                                     |
| ------------------------------ | ------------------------------------------------------------------------ |
| `ss -tlnp`                     | Lister les services qui écoutent, et sur quelles interfaces              |
| `sudo iptables -L nixos-fw -n` | Afficher les règles du pare-feu NixOS, quand il est activé               |
| `sudo systemctl stop firewall` | Arrêter le pare-feu jusqu'au prochain redémarrage ou switch, pour tester |

## Sources

- [Firewall, manuel NixOS](https://nixos.org/manual/nixos/stable/#sec-firewall)
- [Firewall, wiki NixOS](https://wiki.nixos.org/wiki/Firewall)
