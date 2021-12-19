#!/usr/bin/with-contenv bashio
CONFIG_PATH=/data/options.json

CERT_PATH=/ssl/lego
mkdir -p ${CERT_PATH}
mkdir -p ${CERT_PATH}/certificates

declare cmd
declare args
declare challange
declare renew_threshold
declare interval
declare log_level

## defaults
# set log.level
if bashio::config.has_value 'log_level'; then
    bashio::log.level $(bashio::config 'log_level')
fi

# Set challange
if bashio::config.has_value 'challange'; then
    challange=$(bashio::config 'challange')
else
    challange=http
fi
bashio::log.debug "config::challange ${challange}"

# Set renew_threshold
if bashio::config.has_value 'renew_threshold'; then
    renew_threshold=$(bashio::config 'renew_threshold')
else
    renew_threshold=45
fi
bashio::log.debug "config::renew_threshold ${renew_threshold}"

# Set interval
if bashio::config.has_value 'interval'; then
    interval=$(bashio::config 'interval')
else
    interval=1d
fi
bashio::log.debug "config::interval ${interval}"

bashio::log.debug "config::provider $(bashio::config 'provider')"
bashio::log.debug "config::domains $(bashio::config 'domains')"
bashio::log.debug "config::email $(bashio::config 'email')"
bashio::log.debug "config::env_vars $(bashio::config 'env_vars')"


# Export env vars
for var in $(bashio::config 'env_vars|keys'); do
    name=$(bashio::config "env_vars[${var}].name")
    value=$(bashio::config "env_vars[${var}].value")

    # sanitize env value
    len=$((${#value} - 3))
    str=""
	for i in {1..$1}; do str=${str}*; done
    sanitized_value=${str}$(echo ${value} | grep -o ...$)

    bashio::log.info "Setting ${name} to ${sanitized_value}"
    export "${name}=${value}"
done

args="--accept-tos"

# Add email argument. Needed by both http and dns challanges
args="${args} --email $(bashio::config 'email')"

# Add output folder argument
args="${args} --path ${CERT_PATH}"

# Create domains list. Needed by both http and dns challanges
for domain in $(bashio::config 'domains'); do
    bashio::log.debug "adding domain ${domain}"
    args="${args} --domains ${domain}"
done

# select challange
if [ "${challange}" == "dns" ]; then
    args="${args} --dns $(bashio::config 'provider')"
else
    args="${args} --http --http.port :80"
fi

# sellect command
if [[ -z `ls -A "${CERT_PATH}/certificates"` ]]; then
    cmd="run"
else
    cmd="renew --days ${renew_threshold}"
fi

# create/renew certificate
while true
do
    bashio::log.debug "running command: /lego ${args} ${cmd}"
    lego ${args} ${cmd}
    bashio::log.log "sleeping for ${interval}"
	sleep ${interval}
done
