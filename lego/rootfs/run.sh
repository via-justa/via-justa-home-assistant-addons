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
bashio::log.debug "config::renew_threshold ${renew_threshold} days"

# Set check_time
check_time=$(config check_time "04:00")
bashio::log.debug "config::check_time ${check_time}"

bashio::log.debug "config::provider $(bashio::config 'provider')"
bashio::log.debug "config::domains $(bashio::config 'domains')"
bashio::log.debug "config::email $(bashio::config 'email')"
bashio::log.debug "config::restart $(bashio::config 'restart')"
bashio::log.debug "config::addons $(bashio::config 'addons')"

# Export env vars
for var in $(bashio::config 'env_vars|keys'); do
    name=$(bashio::config "env_vars[${var}].name")
    value=$(bashio::config "env_vars[${var}].value")

    env_export ${name} ${value}
done

bashio::log.info "using challenge ${challenge}"

args="--accept-tos --email $(bashio::config 'email') --path ${CERT_PATH}"


# Log domain list
for domain in $(bashio::config 'domains'); do
    sans=(${$domain//,/ })
    bashio::log.info "Monitoring certificate for ${sans[0]}"
done

# select challenge
if [ "${challenge}" == "dns" ]; then
    args="${args} --dns $(bashio::config 'provider')"
else
    args="${args} --http"
fi

# create new certificates
for domain in $(bashio::config 'domains'); do
    sans=(${$domain//,/ })
    bashio::log.debug "Checking for certificate ${CERT_PATH}/certificates/${sans[0]}.crt existence "
    if [[ ! -f "${CERT_PATH}/certificates/${sans[0]}.crt" ]]; then
        bashio::log.debug "running command: lego ${args} run"
        bashio::log.info "Certificate for domain ${sans[0]} not found, issuing"
        domainargs=$args
        for san in ${sans[@]}; do
            domainargs="${domainargs} -d ${san}"
        done
        lego ${domainargs} run
    else
        bashio::log.info "Certificate for domain ${sans[0]} found"
    fi
done

# create/renew certificate
while true
do
    if [ "$(date +"%H:%M")" == "$check_time" ]; then
        update ${args}
    fi
    sleep 60
done
