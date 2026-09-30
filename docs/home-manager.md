---
title: Home Manager
description: Comment les applications et leurs fichiers de configuration sont gérés avec home-manager
icon: material/home-account
status: draft
createdAt: 2026-09-30
modifyAt: 2026-09-30
todo:
  - "[x] Choisir comment les applications home-manager sont réparties entre les machines"
---

# Home Manager

> Où s'installent les applications, comment leurs fichiers de configuration sont déposés, et pourquoi.

## Integration

home-manager est installé en **module NixOS**, dans `modules/users/mathod.nix`. Un seul switch applique le système et la configuration utilisateur, dans la même génération:

``` { .console .codeblock }
$ nh os switch github:Mathod95/nixos --refresh
```

Réglages du module:

- `useGlobalPkgs = true`: home-manager utilise les mêmes paquets que le système, donc aussi `allowUnfree` du profil `minimal`.
- `useUserPackages = true`: Les paquets de l'utilisateur sont installés dans `/etc/profiles/per-user/mathod`.
- `backupFileExtension = "bak"`: Si un fichier existe déjà à l'endroit où home-manager veut déposer le sien, il est renommé en `.bak` au lieu de bloquer le switch.

## Where things go

| What                                                             | Where                                          |
| ---------------------------------------------------------------- | ---------------------------------------------- |
| Toutes les applications, avec ou sans configuration              | home-manager (`home.packages`)                 |
| Leurs fichiers de configuration, quand ils existent              | home-manager (`xdg.configFile` ou `home.file`) |
| Le système: Démarrage, réseau, audio, bureau, shell de connexion | NixOS                                          |

C'est la répartition recommandée par le [NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager): NixOS pour les composants essentiels du système et ce dont tous les utilisateurs ont besoin, home-manager pour tout le reste. Ce qui est installé au niveau système tourne souvent avec des droits root: Moins il y en a, mieux c'est.

!!! success "Decision"
    **Un seul endroit pour tous les paquets: home-manager.** Une application sans configuration à fournir s'installe quand même avec home-manager, et garde son comportement par défaut. Le jour où une configuration est ajoutée, le fichier vient simplement à côté, dans le même module.

## Config files

Une application avec une configuration à fournir s'écrit toujours de la même façon: Le paquet, plus le fichier natif de l'application, hébergé dans le repo à côté du module.

``` { .nix .codeblock title="modules/programs/fastfetch/fastfetch.nix" }
{
  flake.modules.homeManager.fastfetch = { pkgs, ... }: {
    home.packages = [ pkgs.fastfetch ];
    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
  };
}
```

``` { .nix .codeblock title="modules/programs/btop/btop.nix" }
{
  # Sans configuration à fournir: Le paquet seul
  flake.modules.homeManager.btop = { pkgs, ... }: {
    home.packages = [ pkgs.btop ];
  };
}
```

- **`xdg.configFile."<app>/<fichier>"`** dépose le fichier dans `~/.config/<app>/<fichier>`. Un dossier entier fonctionne aussi: `xdg.configFile."btop".source = ./btop;`.
- **`home.file."<chemin>"`** dépose un fichier ailleurs dans le dossier personnel, pour les applications qui ne lisent pas `~/.config` (par exemple `~/.zshrc`).
- **C'est l'application qui décide où elle lit sa configuration**, pas home-manager. La plupart lisent `~/.config/<app>/`. zsh lit `~/.zshrc`, sauf si la variable `ZDOTDIR` lui indique un autre dossier, par exemple `~/.config/zsh`.
- **import-tree n'importe que les fichiers `.nix`**: Les fichiers de configuration peuvent donc vivre dans le même dossier que leur module.

### Methods

Toutes les façons de gérer la configuration d'une application avec home-manager:

| #   | Approach                   | How                                                                               | Result                                                          |
| --- | -------------------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| A   | Tout en Nix                | Module `programs.<app>` et ses options, home-manager génère le fichier            | Pas de fichier natif, la configuration s'écrit en Nix           |
| B   | Paquet + fichier natif     | `home.packages` + `xdg.configFile` / `home.file`, sans activer `programs.<app>`   | Uniforme, un fichier natif par application                      |
| C   | Module + fichier injecté   | `programs.<app>` activé, fichier inséré par une option du module (`initContent`…) | Une option différente par module, et certains n'en ont pas      |
| D   | Module + fichier forcé     | `programs.<app>` activé, fichier imposé par `lib.mkForce`                         | Le module ne sert plus à rien                                   |
| E   | Lien vers un clone du repo | `mkOutOfStoreSymlink` vers le fichier du clone                                    | Modifications sans switch, mais dépend de l'état du clone local |
| F   | Hors home-manager          | stow, chezmoi, yadm…                                                              | Un second outil à côté de Nix                                   |

home-manager compte environ 600 modules (425 [programs](https://github.com/nix-community/home-manager/tree/master/modules/programs), 177 [services](https://github.com/nix-community/home-manager/tree/master/modules/services)), qui ne se comportent pas tous pareil. Un module `programs.<app>` activé écrit souvent lui-même le fichier de configuration (zsh écrit toujours `~/.zshrc`), et entre alors en conflit avec un fichier déposé à la main. D'autres, comme fastfetch, ne l'écrivent que si on leur donne des `settings`. Une règle uniforme évite de vérifier le comportement de chaque module.

!!! success "Decision"
    **La méthode B est retenue pour toutes les applications**, sans exception: `home.packages` + le fichier natif quand il existe. Les modules `programs.<app>` de home-manager ne sont pas utilisés pour les applications dont on fournit le fichier.

### Store or local clone

Les fichiers déposés par la méthode B sont copiés dans le store Nix, en lecture seule. Toute modification passe par un commit et un switch.

La méthode E (lien vers un clone du repo) permettait de modifier une configuration sans switch. Elle a été écartée:

- **Chaque machine dépendrait de son propre clone**: Un switch depuis GitHub n'applique pas une modification tant que `git pull` n'a pas été fait dans le clone de la machine.
- **Les configurations ne feraient plus partie des générations**: Un rollback ne les restaurerait pas.
- **Basculer entre les deux modes** demande lui-même un switch à chaque fois.

!!! success "Decision"
    **GitHub est la source de vérité.** Les fichiers de configuration sont copiés dans le store, et chaque modification passe par un switch, comme le reste du système.

!!! tip "Tester sans switch"
    - Beaucoup d'applications savent lire une configuration de test directement: `fastfetch --config ./config.jsonc`, ou `source ./zshrc` dans le terminal pour essayer un `.zshrc`.
    - Un switch qui ne change qu'un fichier de configuration est rapide: Seul ce fichier est reconstruit. Sur la machine où le repo est cloné, `nh os switch .` teste la modification **avant** de la pousser.

## Things to know

!!! warning "Applications that write their own config file"
    Un fichier déposé par home-manager est en lecture seule. Une application qui réécrit elle-même son fichier ne peut plus enregistrer ses réglages. btop, par exemple, réécrit `btop.conf` à sa fermeture par défaut: Avec un fichier fourni par le repo, ses changements de réglages depuis son interface ne sont pas conservés. Pour une telle application, les réglages se font dans le fichier du repo.

!!! info "Applications that need NixOS"
    Certaines applications demandent une intégration au système, que seul un module NixOS apporte. Elles restent côté NixOS, même si leur configuration utilisateur passe par home-manager:

    - **Hyprland, niri**: `programs.hyprland` / `programs.niri`, pour déclarer la session auprès de l'écran de connexion.
    - **Steam**: `programs.steam`, pour les bibliothèques 32 bits et le pare-feu.
    - **Docker, Podman**: `virtualisation.*`, pour le service et les groupes.
    - **zsh comme shell de connexion**: `programs.zsh.enable` et `users.users.mathod.shell`. Le `.zshrc` reste déposé par home-manager.

!!! info "Shell integrations"
    Les modules `programs.<app>` ajoutent souvent tout seuls leur ligne d'activation dans le shell (zoxide, fzf, direnv…). Avec la méthode B, cette ligne s'écrit dans le `.zshrc`, par exemple `eval "$(zoxide init zsh)"`.

## Distribution between machines

Toutes les applications ne vont pas partout: Une application graphique n'a rien à faire sous WSL. Chaque application est un aspect home-manager (`flake.modules.homeManager.<app>`), que le profil concerné ajoute aux utilisateurs de la machine avec `home-manager.sharedModules`.

``` { .nix .codeblock title="modules/gui/gui.nix" }
home-manager.sharedModules = with inputs.self.modules.homeManager; [
  ghostty
];
```

!!! success "Decision"
    **Les applications sont attribuées par profil.** `minimal` apporte les outils console à toutes les machines, WSL compris. `gui` apporte les applications graphiques, sur les machines qui ont un bureau.

## Sources

- [Getting Started with Home Manager, NixOS & Flakes Book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/start-using-home-manager)
- [Home Manager Option Search](https://home-manager-options.extranix.com/)
- [Home Manager manual](https://nix-community.github.io/home-manager/)
