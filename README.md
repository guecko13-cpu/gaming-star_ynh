# Casino Games Fun - YunoHost package

Ce dépôt contient le package YunoHost (packaging v2) pour l'application **Casino Games Fun**.

## Installation via le panel YunoHost

1. Ouvrez **Applications → Installer une application personnalisée**.
2. Renseignez l'URL Git du package : `https://github.com/guecko13-cpu/casino-games-fun_ynh`.
3. Choisissez le domaine et le chemin (par défaut `/`).
4. Validez l'installation.

## Structure attendue du tarball upstream

Le tarball doit contenir les assets **déjà buildés** (pas de build React pendant l'install) :

```
backend/
  server.js
frontend/
  dist/
admin/
  dist/
```

## Publier une release de l'app & mettre à jour le SHA256

1. Créez un tag/release sur le dépôt upstream `casino-games-fun` et attachez un `tar.gz` versionné.
2. Lancez :

```bash
tools/prefetch.sh "https://github.com/guecko13-cpu/casino-games-fun/releases/download/vX.Y.Z/casino-games-fun.tar.gz"
```

3. Copiez le SHA256 obtenu dans `manifest.toml` (`[resources.sources.main].sha256`).
4. Mettez à jour la version `version = "X.Y.Z~ynhN"` si nécessaire.

## Outils

- `tools/smoke.sh <base_url>` : vérifie `/`, `/admin/`, `/api/health` et `/socket.io`.
- `tools/check-no-conflicts.sh` : vérifie l'absence de marqueurs de conflit.
- `tools/prefetch.sh <tarball_url>` : calcule le sha256 d'un tarball.
