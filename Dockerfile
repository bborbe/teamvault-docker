FROM python:3.4.5
MAINTAINER Benjamin Borbe <bborbe@rocketnews.de>
ARG VERSION

RUN set -x \
	&& DEBIAN_FRONTEND=noninteractive apt-get update --quiet \
	&& DEBIAN_FRONTEND=noninteractive apt-get upgrade --quiet --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get install --quiet --yes --no-install-recommends apt-transport-https ca-certificates gettext libffi-dev libldap2-dev libpq-dev libsasl2-dev postgresql postgresql-contrib \
	&& DEBIAN_FRONTEND=noninteractive apt-get autoremove --yes \
	&& DEBIAN_FRONTEND=noninteractive apt-get clean

#RUN git clone -b master --single-branch https://github.com/trehn/teamvault.git /teamvault
RUN git clone -b email-config --single-branch https://github.com/bborbe/teamvault.git /teamvault
ENV HOME /teamvault
WORKDIR /teamvault
RUN pip install -e .
COPY teamvault.cfg /etc/teamvault.cfg.template
COPY teamvault_ldap.cfg /etc/teamvault_ldap.cfg.template
COPY teamvault_email.cfg /etc/teamvault_email.cfg.template
RUN teamvault setup

EXPOSE 8000

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["teamvault","run","--bind=:8000"]
