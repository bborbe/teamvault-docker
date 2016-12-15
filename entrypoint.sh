#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

function escape {
	echo -n "$1" | sed -e 's/@/\\@/g;s/\./\\./g;s/\//\\\//g;'
}

if [ "$1" = 'teamvault' ]; then

	base_url=${BASE_URL:-'teamvault.benjamin-borbe.de'}
	secret_key=${SECRET_KEY:-'Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ='}
	fernet_key=${FERNET_KEY:-'VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs='}
	salt=${SALT:-'YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k='}
	debug=${DEBUG:-'disabled'}
	database_host=${DATABASE_HOST:-'teamvault-postgres'}
	database_name=${DATABASE_NAME:-'teamvault'}
	database_user=${DATABASE_USER:-'teamvault'}
	database_password=${DATABASE_PASSWORD:-'jXDtEhnQlEJjrdT8'}
	database_port=${DATABASE_PORT:-'5432'}

	email_host=${EMAIL_HOST:-'localhost'}
	email_port=${EMAIL_PORT:-'25'}
	email_user=${EMAIL_USER:-''}
	email_password=${EMAIL_PASSWORD:-''}
	email_use_tls=${EMAIL_USE_TLS:-'False'}
	email_use_ssl=${EMAIL_USE_SSL:-'False'}

	ldap_server_uri=${LDAP_SERVER_URI:-'ldaps://ldap.example.com'}
	ldap_bind_dn=${LDAP_BIND_DN:-'cn=root,dc=example,dc=com'}
	ldap_password=${LDAP_PASSWORD:-'example'}
	ldap_user_base_dn=${LDAP_USER_BASE_DN:-'ou=users,dc=example,dc=com'}
	ldap_user_search_filter=${LDAP_USER_SEARCH_FILTER:-'(cn=%%(user)s)'}
	ldap_group_base_dn=${LDAP_GROUP_BASE_DN:-'ou=groups,dc=example,dc=com'}
	ldap_group_search_filter=${LDAP_GROUP_SEARCH_FILTER:-'(objectClass=group)'}
	ldap_require_group=${LDAP_REQUIRE_GROUP:-'cn=employees,ou=groups,dc=example,dc=com'}
	ldap_attr_email=${LDAP_ATTR_EMAIL:-'mail'}
	ldap_attr_first_name=${LDAP_ATTR_FIRST_NAME:-'givenName'}
	ldap_attr_last_name=${LDAP_ATTR_LAST_NAME:-'sn'}
	ldap_admin_group=${LDAP_ADMIN_GROUP:-'cn=admins,ou=groups,dc=example,dc=com'}

	sed_script=""
	for var in email_host email_port email_user email_password email_use_tls email_use_ssl ldap_server_uri ldap_bind_dn ldap_password ldap_user_base_dn ldap_user_search_filter ldap_group_base_dn ldap_group_search_filter ldap_require_group ldap_attr_email ldap_attr_first_name ldap_attr_last_name ldap_admin_group base_url secret_key fernet_key salt debug database_host database_name database_user database_password database_port; do
		value=$(escape "${!var}")
		sed_script+="\$_ =~ s/\{\{$var\}\}/${value}/g;"
	done
	sed_script+="print \$_"

	echo "create teamvault.cfg"
	cat /etc/teamvault.cfg.template | perl -ne "$sed_script" > /etc/teamvault.cfg

	if [ "$EMAIL_ENABLED" = 'true' ]; then
		echo "add email to teamvault.cfg"
		cat /etc/teamvault_email.cfg.template | perl -ne "$sed_script" >> /etc/teamvault.cfg
	fi

	if [ "$LDAP_ENABLED" = 'true' ]; then
		echo "add ldap to teamvault.cfg"
		cat /etc/teamvault_ldap.cfg.template | perl -ne "$sed_script" >> /etc/teamvault.cfg
	fi

	echo "migrate database"
	teamvault upgrade

	echo "starting django $@"
fi

exec "$@"
