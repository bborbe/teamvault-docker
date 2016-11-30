FROM python:3.4.5
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends apt-transport-https ca-certificates gettext libffi-dev libldap2-dev libpq-dev libsasl2-dev postgresql postgresql-contrib \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

RUN git clone -b master --single-branch https://github.com/trehn/teamvault.git /teamvault
ENV HOME /teamvault
WORKDIR /teamvault
RUN pip install -e .
ADD teamvault.cfg /etc/teamvault.cfg.template
ADD teamvault_ldap.cfg /etc/teamvault_ldap.cfg.template
RUN teamvault setup

EXPOSE 8000

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["teamvault","run","--bind=:8000"]
