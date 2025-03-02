FROM ubuntu:22.04
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ARG VERSION

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends \
	apt-transport-https \
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
	python3-distutils \
	python-is-python3 \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

RUN curl -s https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py

RUN git clone -b ${VERSION} --single-branch --depth 1 https://github.com/seibert-media/teamvault.git /teamvault
ENV HOME /teamvault
WORKDIR /teamvault
RUN pip install -e .
COPY files/teamvault.cfg /etc/teamvault.cfg.template
COPY files/teamvault_ldap.cfg /etc/teamvault_ldap.cfg.template
COPY files/teamvault_email.cfg /etc/teamvault_email.cfg.template
ENV PYTHONPATH /teamvault
RUN teamvault setup

EXPOSE 8000

COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["teamvault","run","--bind=:8000"]
