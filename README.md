# Teamvault

DockerImage for running Teamvault.

## Quick Start with Docker Compose

Copy the example environment file and run the services:

```bash
cp .env.example .env
make run
```

Open `http://localhost:8000` in your browser and login with:
- **Username:** `admin`
- **Password:** `admin`

Stop with `Ctrl+C`.

> **Note:** The default superuser is created automatically on first run. Change the credentials in `.env` before deploying to production!

**Alternative - run in background:**

```bash
make start    # Start in background
make logs     # View logs
make stop     # Stop services
```

## Build dockerimage 

Build dockerimage with a specific version. Aviable versions see here: https://github.com/seibert-media/teamvault/tags

```bash
VERSION=0.8.4 make build upload
```

Upload to your dockerhub account.

```bash
IMAGE=yourname/teamvault VERSION=0.8.4 make build upload
```

## Run Postgres

```
docker rm teamvault-db
docker run \
--name teamvault-db \
-p 5432:5432 \
-e POSTGRES_PASSWORD='S3CR3T' \
-e PGDATA='/var/lib/postgresql/data/pgdata' \
-e POSTGRES_USER='teamvault' \
-e POSTGRES_DB='teamvault' \
postgres:9.6
```

## Run Teamvault

```
docker run \
--link teamvault-db:teamvault-db \
-p 8000:8000 \
-e BASE_URL='http://teamvault.example.com' \
-e SECRET_KEY='Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ=' \
-e FERNET_KEY='VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs=' \
-e SALT='YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k=' \
-e DEBUG='enabled' \
-e DATABASE_HOST='teamvault-db' \
-e DATABASE_NAME='teamvault' \
-e DATABASE_USER='teamvault' \
-e DATABASE_PASSWORD='S3CR3T' \
-e DATABASE_PORT='5432' \
-e ALLOWED_HOSTS=localhost \
bborbe/teamvault:1.0.0
```

## Create superuser

```
docker run -ti \
--link teamvault-db:teamvault-db \
-e BASE_URL='http://teamvault.example.com' \
-e SECRET_KEY='Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ=' \
-e FERNET_KEY='VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs=' \
-e SALT='YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k=' \
-e DEBUG='enabled' \
-e DATABASE_HOST='teamvault-db' \
-e DATABASE_NAME='teamvault' \
-e DATABASE_USER='teamvault' \
-e DATABASE_PASSWORD='S3CR3T' \
-e DATABASE_PORT='5432' \
bborbe/teamvault:1.0.0 \
teamvault plumbing createsuperuser
```

## Ready to run
 
`open http://teamvault-address:8000` 


## Run Teamvault with ldap

```
docker run \
-p 8000:8000 \
-e BASE_URL='http://teamvault.example.com' \
-e SECRET_KEY='Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ=' \
-e FERNET_KEY='VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs=' \
-e SALT='YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k=' \
-e DEBUG='enabled' \
-e DATABASE_HOST='postgres.example.com' \
-e DATABASE_NAME='teamvault' \
-e DATABASE_USER='teamvault' \
-e DATABASE_PASSWORD='jXDtEhnQlEJjrdT8' \
-e DATABASE_PORT='5432' \
-e LDAP_ENABLED='true' \
-e LDAP_SERVER_URI='ldap://ldap.example.com' \
-e LDAP_BIND_DN='cn=root,dc=example,dc=com' \
-e LDAP_PASSWORD='S3CR3T' \
-e LDAP_USER_BASE_DN='ou=users,dc=example,dc=com' \
-e LDAP_USER_SEARCH_FILTER='(uid=%%(user)s)' \
-e LDAP_GROUP_BASE_DN='ou=groups,dc=example,dc=com' \
-e LDAP_GROUP_SEARCH_FILTER='(objectClass=groupOfNames)' \
-e LDAP_REQUIRE_GROUP='ou=employees,ou=groups,dc=example,dc=com' \
-e LDAP_ADMIN_GROUP='ou=admins,ou=groups,dc=example,dc=com' \
-e LDAP_ATTR_EMAIL='mail' \
-e LDAP_ATTR_FIRST_NAME='givenName' \
-e LDAP_ATTR_LAST_NAME='sn' \
bborbe/teamvault:1.0.0
```

## Run Teamvault with custom email server

```
docker run \
-p 8000:8000 \
-e BASE_URL='http://teamvault.example.com' \
-e SECRET_KEY='Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ=' \
-e FERNET_KEY='VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs=' \
-e SALT='YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k=' \
-e DEBUG='enabled' \
-e DATABASE_HOST='postgres.example.com' \
-e DATABASE_NAME='teamvault' \
-e DATABASE_USER='teamvault' \
-e DATABASE_PASSWORD='S3CR3T' \
-e DATABASE_PORT='5432' \
-e EMAIL_ENABLED='true' \
-e EMAIL_HOST='localhost' \
-e EMAIL_PORT='25' \
-e EMAIL_USER='smtp@example.com' \
-e EMAIL_PASSWORD='S3CR3T' \
-e EMAIL_USE_TLS='False' \
-e EMAIL_USE_SSL='False' \
bborbe/teamvault:1.0.0
```

## Sources

https://github.com/seibert-media/teamvault
