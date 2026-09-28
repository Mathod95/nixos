# nixos

Configuration NixOS personnelle en Nix flakes, pour 7 machines, avec home-manager, secrets chiffrés via sops-nix + age, et partitionnement déclaratif via disko.

La documentation du projet (veille, architecture cible, scope) est publiée sur [mathod95.github.io/nixos](https://mathod95.github.io/nixos/).

## Structure

- `docs/` contient le contenu Markdown du site de documentation, ainsi que les scripts et styles additionnels (`docs/javascripts/`, `docs/stylesheets/`).
- `overrides/` contient les templates HTML surchargeant ceux du thème Zensical.
- `zensical.toml` est la configuration du site (navigation, thème, extensions Markdown).
- `.github/workflows/docs.yml` construit et publie le site sur GitHub Pages à chaque changement sur `docs/`, `overrides/`, `zensical.toml` ou le workflow lui-même.

Les personnalisations du site (toggle-sidebar, on-this-page, codeBlock, open-in-new-tab, placeholders) viennent du dépôt [Mathod95/zensical](https://github.com/Mathod95/zensical).

## Documentation en local

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install zensical
zensical serve
```

Le site est servi sur `http://localhost:8000`.
