FROM ubuntu:24.04

ARG VERSION
ARG BUILD_GIT_VERSION=dev
ARG BUILD_GIT_COMMIT=none
ARG BUILD_DATE=unknown

LABEL org.opencontainers.image.created="${BUILD_DATE}" \
      org.opencontainers.image.version="${BUILD_GIT_VERSION}" \
      org.opencontainers.image.revision="${BUILD_GIT_COMMIT}" \
      org.opencontainers.image.title="teamvault" \
      org.opencontainers.image.description="TeamVault - Password Management for Teams" \
      org.opencontainers.image.authors="Benjamin Borbe <benjamin.borbe@gmail.com>" \
      org.opencontainers.image.source="https://github.com/seibert-media/teamvault"

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends \
	build-essential \
	ca-certificates \
	curl \
	gettext \
	git \
	libffi-dev \
	libldap2-dev \
	libpq-dev \
	libsasl2-dev \
	libssl-dev \
	nodejs \
	npm \
	postgresql \
	postgresql-contrib \
	python3 \
	python3-dev \
	python3-pip \
	python-is-python3 \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

RUN git clone -b ${VERSION} --single-branch --depth 1 https://github.com/seibert-media/teamvault.git /teamvault
ENV HOME=/teamvault
WORKDIR /teamvault
RUN python3 - <<'PY'
from pathlib import Path
p = Path('/teamvault/teamvault/settings.py')
text = p.read_text()
if 'import os\n' not in text:
    text = 'import os\n' + text
if 'CSRF_TRUSTED_ORIGINS' not in text:
    marker = "SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')\n"
    inject = marker + "CSRF_TRUSTED_ORIGINS = [origin.strip() for origin in os.getenv('CSRF_TRUSTED_ORIGINS', '').split(',') if origin.strip()]\n"
    text = text.replace(marker, inject)
p.write_text(text)
PY
RUN pip install --break-system-packages -e .
RUN npm install && npm run build
COPY files/teamvault.cfg /etc/teamvault.cfg.template
COPY files/teamvault_ldap.cfg /etc/teamvault_ldap.cfg.template
COPY files/teamvault_email.cfg /etc/teamvault_email.cfg.template
COPY files/create_superuser.py /usr/local/bin/create_superuser.py
ENV PYTHONPATH=/teamvault
RUN teamvault setup

EXPOSE 8000

COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["teamvault","run","--bind=:8000"]
