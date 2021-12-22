#!/usr/bin/with-contenv bashio
CONFIG_PATH=/data/options.json

source /opt/functions.sh

CERT_PATH=/ssl/lego
mkdir -p ${CERT_PATH}
mkdir -p ${CERT_PATH}/certificates

declare cmd
declare args
declare challenge
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

# Set challenge
challenge=$(config challenge "http")
bashio::log.debug "config::challenge ${challenge}"

# Set renew_threshold
renew_threshold=$(config renew_threshold "30")
bashio::log.debug "config::renew_threshold ${renew_threshold}"

bashio::log.debug "config::provider $(bashio::config 'provider')"
bashio::log.debug "config::domains $(bashio::config 'domains')"
bashio::log.debug "config::email $(bashio::config 'email')"

# Export env vars
for var in $(bashio::config 'env_vars|keys'); do
    name=$(bashio::config "env_vars[${var}].name")
    value=$(bashio::config "env_vars[${var}].value")

    env_export ${name} ${value}
done

bashio::log.info "using challenge ${challenge}"

# set default common arguments
args="--accept-tos --email $(bashio::config 'email') --path ${CERT_PATH}"

# Log domain list
for domain in $(bashio::config 'domains'); do
    bashio::log.info "Monitoring certificate for ${domain}"
done

# select challenge
if [ "${challenge}" == "dns" ]; then
    args="${args} --dns $(bashio::config 'provider')"
else
    args="${args} --http"
fi

# create new certificates
for domain in $(bashio::config 'domains'); do
    if [[ -z "${CERT_PATH}/certificates/${domain}.crt" ]]; then
        bashio::log.debug "running command: lego ${1} run"
        bashio::log.info "Certificate for domain ${domain} not found, issuing"
        lego ${args} run
    else
        bashio::log.info "Certificate for domain ${domain} found"
    fi
done

# create/renew certificate
while true
do
    if [ "$(date +"%H:%M")" == "$(bashio::config 'check_time')" ]; then
        update ${args}
    fi
    sleep 60
done
