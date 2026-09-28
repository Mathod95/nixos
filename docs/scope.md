# Scope

Reformulation du besoin, pour savoir précisément ce qui est attendu, ce qui ne l'est pas encore, et ce qui reste à trancher.

## Objectif

Réécrire **from scratch** la configuration NixOS personnelle, en **Nix flakes**, pour qu'un seul dépôt décrive et déploie **7 machines** différentes, avec des profils réutilisables, des secrets chiffrés commités dans un **dépôt public**, et une installation reproductible jusqu'au partitionnement des disques.

## Périmètre

| # | Sujet | Attendu |
| --- | --- | --- |
| 1 | **Flakes** | Un `flake.nix` unique à la racine, `flake.lock` versionné, inputs alignés sur le même nixpkgs (`follows`). |
| 2 | **Modules NixOS** | Configuration découpée en modules réutilisables, conforme aux pratiques de la documentation officielle. |
| 3 | **home-manager** | Configuration utilisateur déclarative, intégrée au déploiement système. |
| 4 | **Multi-machines** | 7 hôtes décrits dans le même dépôt, chacun composé à partir de profils communs. |
| 5 | **Profils** | `minimal`, `wsl`, `wm`, `laptop`, `desktop`, `workstation`. |
| 6 | **Secrets** | sops-nix + age. Les fichiers chiffrés sont commités dans le dépôt public, aucune valeur sensible en clair. |
| 7 | **Partitionnement** | Disques décrits en Nix (disko), installation d'une nouvelle machine en une commande (nixos-anywhere ou disko-install). |
| 8 | **Veille** | Identifier les outils et pratiques actuels ("must have") et les intégrer quand ils apportent un vrai gain. |
| 9 | **Documentation** | Ce site zensical, publié sur GitHub Pages via GitHub Actions. |

## Hors périmètre (sauf demande contraire)

Ces sujets n'ont pas été demandés, ils ne sont pas traités tant qu'ils ne sont pas explicitement ajoutés:

- macOS / nix-darwin;
- serveurs et services auto-hébergés;
- déploiement automatique en continu sur les machines (comin, deploy-rs, colmena), au-delà d'un déploiement manuel.

## Contraintes

- **Dépôt public**: tout ce qui est commité est lisible par tous. Les secrets sont chiffrés, et les métadonnées sensibles (IP, domaines, emails, SSID) sont évitées ou chiffrées.
- **Reproductibilité**: une machine doit pouvoir être réinstallée à l'identique depuis le dépôt et la seule clé age personnelle.
- **Version cible**: NixOS 26.05 comme base, avec la migration vers 26.11 (fin novembre 2026) anticipée.

## Sources de référence

- Documentation officielle: [NixOS manual](https://nixos.org/manual/nixos/stable/), [Home Manager manual](https://nix-community.github.io/home-manager/), [sops-nix](https://github.com/Mic92/sops-nix), [disko](https://github.com/nix-community/disko).
- [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/).
- [Documentation Nix de Stéphane Robert](https://blog.stephane-robert.info/docs/admin-serveurs/linux/references-complementaires/nix/).
- Dépôts `.nix` d'autres utilisateurs, à partager au fil du projet.

## Critères de réussite

- [ ] `nix flake check` passe, en local et en CI.
- [ ] Chacun des 7 hôtes se construit (`nix build .#nixosConfigurations.<host>.config.system.build.toplevel`).
- [ ] Un secret n'est déchiffrable que par l'admin et les machines prévues dans `.sops.yaml`.
- [ ] Une nouvelle machine s'installe, partitionnement compris, depuis une seule commande.
- [ ] Aucune valeur sensible en clair dans l'historique git.

## Étapes

1. ~~Veille et état de l'art~~ (voir [Accueil](index.md)).
2. ~~Site de documentation~~ (ce site).
3. Installation basique du laptop avec l'installeur classique (sans disko ni Secure Boot), pour avoir une machine de travail. Une réinstallation est prévue à l'étape 8, une fois disko prêt.
4. Trancher les questions ouvertes ci-dessous.
5. Squelette du flake: inputs, structure, formatage, CI.
6. Profil `minimal` et hôte WSL (le premier testable sans réinstaller de machine).
7. Secrets: clé admin, `.sops.yaml`, premier secret.
8. disko + nixos-anywhere sur une première machine physique (réinstallation du laptop).
9. Profils graphiques (`wm`, `laptop`, `desktop`, `workstation`), puis le reste des hôtes.

## Questions ouvertes

- [ ] **Les 7 machines**: nom, profil, CPU/GPU (Intel, AMD, NVIDIA), disque, chiffrement ou non.
- [ ] **WM / compositor**: Hyprland, niri, sway, autre ? Et shell, éditeur, terminal.
- [ ] **Canal**: stable 26.05 + overlay unstable, ou tout en unstable ?
- [ ] **Impermanence et Secure Boot**: dès le départ ou plus tard ?
- [ ] **Structure**: pattern dendritique ou structure classique `hosts/` + `modules/` ?
- [ ] **Secrets**: dans ce dépôt public, ou dans un second dépôt privé ?
- [ ] **Dépôts de référence**: lesquels étudier ?
