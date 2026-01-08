## Maintenance

L'interface de maintenance YunoHost est disponible sur `/ynh-maintenance`.
Elle est protégée par la permission dédiée `maintenance` (groupe `admins` par défaut).

Depuis cette interface, vous pouvez :
- lancer un upgrade
- consulter les logs d'upgrade

## Token GitHub

Le dépôt upstream est privé. Un token GitHub avec accès lecture doit être fourni lors de l'installation ou de l'upgrade.
Le token est enregistré dans les paramètres de l'application et n'est jamais affiché dans les logs.

Pour le mettre à jour :

```bash
yunohost app setting set gaming-star --key=github_token --value="TOKEN"
```
