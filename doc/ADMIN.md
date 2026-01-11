# Casino Games Fun - Administration

## Services

- Backend Node.js : service systemd `casino-games-fun`.
- Nginx sert :
  - `/` → frontend statique
  - `/admin/` → admin statique
  - `/api/` et `/socket.io/` → reverse-proxy vers le backend

## Logs

- Journaux systemd : `journalctl -u casino-games-fun`

## Configuration

- Le fichier `.env` est stocké dans le répertoire data de l'application.
- Les variables critiques : `PORT`, `JWT_SECRET`, `DATABASE_URL`.

## Vérifications rapides

```bash
curl -fsS http://127.0.0.1:<port>/api/health
```

Remplacez `<port>` par le port interne attribué à l'installation.
