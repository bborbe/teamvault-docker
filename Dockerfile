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
      org.opencontainers.image.source="https://github.com/bborbe/teamvault"

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
	postgresql \
	postgresql-contrib \
	python3 \
	python3-dev \
	python3-pip \
	python-is-python3 \
	unzip \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

# The v0.13.0 frontend builds with Rspack 2.x, which requires Node >=20.19
# (or >=22.12) — Ubuntu 24.04's apt nodejs is 18. Upstream builds with bun
# (bun.lock pins @rspack/core 2.0.1; their CI runs `bun install --frozen-lockfile
# && bun run build`). Install bun (brings its own runtime) and build with it —
# npm without a lockfile resolves newer Rspack 2.1.x which rejects the
# top-level `cache.type: filesystem` in rspack.common.js.
RUN git clone -b ${VERSION} --single-branch --depth 1 https://github.com/bborbe/teamvault.git /teamvault
ENV HOME=/teamvault
WORKDIR /teamvault
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="${HOME}/.bun/bin:${PATH}"
RUN pip install --break-system-packages -e .
RUN bun install --frozen-lockfile && bun run build
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
