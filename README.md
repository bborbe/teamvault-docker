# TeamVault Docker

Docker image + compose setup for running [TeamVault](https://github.com/bborbe/teamvault).

## Security first

This image now **requires** these environment variables at runtime:

- `SECRET_KEY`
- `FERNET_KEY`
- `SALT`
- `DATABASE_PASSWORD`

If any are missing, container startup fails fast.

For production, also ensure:

- `DEBUG=disabled`
- strong unique admin credentials
- TLS termination in front of TeamVault
- regular DB backups

---

## Quick start (local dev)

```bash
cp .env.example .env
# edit .env and set secure values at least for:
# SECRET_KEY, FERNET_KEY, SALT, DATABASE_PASSWORD, SUPERUSER_PASSWORD

make run
```

Open <http://localhost:8000>.

Alternative:

```bash
make start
make logs
make stop
```

---

## Build image

Use an explicit TeamVault release tag from:
<https://github.com/bborbe/teamvault/tags>

```bash
VERSION=0.11.8 make build
```

Push to your own registry:

```bash
REGISTRY=docker.io IMAGE=yourname/teamvault VERSION=0.11.8 make build upload
```

---

## Docker compose

`docker-compose.yml` uses:

- `postgres:16`
- `docker.io/bborbe/teamvault:${VERSION:-0.11.8}`

Set `VERSION` in `.env` if you want a different TeamVault tag.

---

## Manual docker run (reference)

### Postgres

```bash
docker run -d \
  --name teamvault-db \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD='replace-me' \
  -e PGDATA='/var/lib/postgresql/data/pgdata' \
  -e POSTGRES_USER='teamvault' \
  -e POSTGRES_DB='teamvault' \
  postgres:16
```

### TeamVault

```bash
docker run --rm \
  --link teamvault-db:teamvault-db \
  -p 8000:8000 \
  -e BASE_URL='http://teamvault.example.com' \
  -e SECRET_KEY='replace-me' \
  -e FERNET_KEY='replace-me' \
  -e SALT='replace-me' \
  -e DEBUG='disabled' \
  -e DATABASE_HOST='teamvault-db' \
  -e DATABASE_NAME='teamvault' \
  -e DATABASE_USER='teamvault' \
  -e DATABASE_PASSWORD='replace-me' \
  -e DATABASE_PORT='5432' \
  -e SUPERUSER_NAME='admin' \
  -e SUPERUSER_PASSWORD='replace-me' \
  -e SUPERUSER_EMAIL='admin@example.com' \
  bborbe/teamvault:0.11.8
```

---

## LDAP / Email

LDAP and email settings are template-driven via environment variables.
See:

- `files/teamvault_ldap.cfg.template`
- `files/teamvault_email.cfg.template`

---

## Source

- TeamVault upstream: <https://github.com/bborbe/teamvault>
- This docker wrapper: <https://github.com/bborbe/teamvault-docker>
