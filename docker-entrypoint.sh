#!/bin/bash

set -e

if [ -v DB_PASSWORD_FILE ]; then
    DB_PASSWORD="$(< $DB_PASSWORD_FILE)"
fi

# set the postgres database host, port, user and password according to the environment
# and pass them as arguments to the odoo process if not present in the config file
: ${DB_HOST:=${POSTGRES_PORT_5432_TCP_ADDR:='odoo-database'}}
: ${DB_PORT:=${POSTGRES_PORT_5432_TCP_PORT:='5432'}}
: ${DB_USER:=${POSTGRES_USER:=${POSTGRES_USER:='odoo'}}}
: ${DB_PASSWORD:=${POSTGRES_PASSWORD:=${POSTGRES_PASSWORD:='password'}}}

DB_ARGS=()
function check_config() {
    param="$1"
    value="$2"
    if grep -q -E "^\s*\b${param}\b\s*=" "$ODOO_RC" ; then
        value=$(grep -E "^\s*\b${param}\b\s*=" "$ODOO_RC" |cut -d " " -f3|sed 's/["\n\r]//g')
    fi;
    DB_ARGS+=("--${param}")
    DB_ARGS+=("${value}")
}

check_config "db_host" "$DB_HOST"
check_config "db_port" "$DB_PORT"
check_config "db_user" "$DB_USER"
check_config "db_password" "$DB_PASSWORD"

case "$1" in
    -- | odoo)
        shift
        if [[ "$1" == "scaffold" ]] ; then
            exec odoo "$@"
        else
            wait-for-psql.py ${DB_ARGS[@]} --timeout=30
            exec odoo "$@" "${DB_ARGS[@]}"
        fi
        ;;
    -*)
        wait-for-psql.py ${DB_ARGS[@]} --timeout=30
        exec odoo "$@" "${DB_ARGS[@]}"
        ;;
    *)
        exec "$@"
esac

exit 1
