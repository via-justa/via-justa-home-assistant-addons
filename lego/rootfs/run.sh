#!/usr/bin/with-contenv bashio
CONFIG_PATH=/data/options.json

source /functions.sh

CERT_PATH=/ssl/lego
mkdir -p ${CERT_PATH}
mkdir -p ${CERT_PATH}/certificates

declare cmd
declare args
declare challange
declare renew_threshold
declare log_level

## defaults
# set log.level
if bashio::config.has_value 'log_level'; then
    bashio::log.level $(bashio::config 'log_level')
fi

# Set timezone
cp /usr/share/zoneinfo/$(get_tz) /etc/localtime
bashio::log.debug "config::timezone $(get_tz)"

# Set challange
challange=$(config challange "http")
bashio::log.debug "config::challange ${challange}"

# Set renew_threshold
renew_threshold=$(config renew_threshold "30")
bashio::log.debug "config::renew_threshold ${renew_threshold}"

# Set port
port=$(config port 8091)
bashio::log.debug "config::port ${port}"

bashio::log.debug "config::provider $(bashio::config 'provider')"
bashio::log.debug "config::domains $(bashio::config 'domains')"
bashio::log.debug "config::email $(bashio::config 'email')"
bashio::log.debug "config::env_vars $(bashio::config 'env_vars')"

# Export env vars
for var in $(bashio::config 'env_vars|keys'); do
    name=$(bashio::config "env_vars[${var}].name")
    value=$(bashio::config "env_vars[${var}].value")

    env_export ${name} ${value}
done

# set default common arguments
args="--accept-tos --email $(bashio::config 'email') --path ${CERT_PATH}"

# Create domains list. Needed by both http and dns challanges
for domain in $(bashio::config 'domains'); do
    bashio::log.debug "adding domain ${domain}"
    args="${args} --domains ${domain}"
done

# select challange
if [ "${challange}" == "dns" ]; then
    args="${args} --dns $(bashio::config 'provider')"
else
    args="${args} --http --http.port :${port}"
fi

# create/renew certificate
while true
do
    if [ "$(date +"%H:%M")" == "$(bashio::config 'check_time')" ]; then
        execute ${args}
    fi
    sleep 60
done
