# Gaming Star YunoHost package

Ce dépôt fournit le package YunoHost v2 pour l'application PHP **gaming-star** (upstream privé).

## Installation via le panel

1. Ouvrez **Applications** → **Installer une application personnalisée**.
2. Saisissez l'URL Git : `https://github.com/guecko13-cpu/gaming-star_ynh`.
3. Renseignez le token GitHub (PAT fine-grained, lecture seule sur le dépôt upstream).
4. Validez l'installation.

## Notes

- Le dépôt upstream est privé, les sources ne sont **pas** incluses dans ce package.
- Le token GitHub est stocké dans les paramètres de l'app et n'est jamais affiché dans les logs.
- L'interface de maintenance est accessible sur `/ynh-maintenance` et protégée par la permission YunoHost `maintenance`.
