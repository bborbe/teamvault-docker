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
	python-is-python3 \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py --break-system-packages

RUN git clone -b ${VERSION} --single-branch --depth 1 https://github.com/seibert-media/teamvault.git /teamvault
ENV HOME=/teamvault
WORKDIR /teamvault
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
