#!/bin/bash

set -e

if [ "$1" = 'teamvault' ]; then

	base_url=${BASE_URL:-'teamvault.benjamin-borbe.de'}
	secret_key=${SECRET_KEY:-'Lk0nKXc2eE55MUg2KHFecUVHW1BzSFc5Kl0jPz1HQ0JLejcpVHJ1UjdtJnJAbyxkfSQ='}
	fernet_key=${FERNET_KEY:-'VE_jV0JFmi8r0SqT_fJRHwDatSqSWa9xz_vi3fbahFs='}
	salt=${SALT:-'YFp5c2Y/KWZaeGVgaS47NSNRKSNoOXpOZkxlMDp1ZXtsWX09OmEkK2tuPS1pSk46U3k='}
	debug=${DEBUG:-'enabled'}
	database_host=${DATABASE_HOST:-'teamvault-postgres'}
	database_name=${DATABASE_NAME:-'teamvault'}
	database_user=${DATABASE_USER:-'teamvault'}
	database_password=${DATABASE_PASSWORD:-'jXDtEhnQlEJjrdT8'}
	database_port=${DATABASE_PORT:-'5432'}

	sed_script=""
	for var in base_url secret_key fernet_key salt debug database_host database_name database_user database_password database_port; do
		sed_script+="s,{{$var}},${!var},g;"
	done

	echo "create teamvault.cfg"
	cat /etc/teamvault.cfg.template | sed -e "$sed_script" > /etc/teamvault.cfg

	echo "migrate database"
	teamvault upgrade

	echo "starting django $@"
fi

exec "$@"
