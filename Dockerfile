FROM python:3.4.5
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends apt-transport-https ca-certificates gettext libffi-dev libldap2-dev libpq-dev libsasl2-dev postgresql postgresql-contrib \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

RUN pip install teamvault
ADD teamvault.cfg /etc/teamvault.cfg.template
RUN teamvault setup
ADD config.py /usr/local/lib/python3.4/site-packages/teamvault/apps/settings/config.py

EXPOSE 8000

COPY entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["teamvault","run"]
