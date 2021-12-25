
# Call: config <config key> <default value>
config() {
    if bashio::config.has_value "$1"; then
        echo $(bashio::config "$1")
    else
        echo $2
    fi
}

# Call: env_export <key> <value>
env_export() {
    len=$((${#2} - 3))
    str=""
	for i in $(seq ${len}); do str=${str}*; done
    sanitized_value=${str}$(echo ${2} | grep -o ...$)

    bashio::log.debug "Setting ${1} to ${sanitized_value}"
    export "${1}=${2}"
}

get_tz() {
    curl -sSL -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/info | jq -r '.data.timezone'
}

update() {
    for domain in $(bashio::config 'domains'); do
        bashio::log.debug "checking domain ${domain}"
        args="${@} --domains ${domain}"

        bashio::log.debug "running command: lego ${@} renew --days ${renew_threshold} --renew-hook /opt/restart_ha_hook.sh"
        bashio::log.info "Certificate for domain ${domain} found, checking if renew needed"
        if $(bashio::config 'restart'); then
            lego ${args} --domains ${domain} renew --days ${renew_threshold} --renew-hook /opt/restart_ha_hook.sh
        else
            lego ${args} --domains ${domain} renew --days ${renew_threshold}
            bashio::log.info "Certificate for domain ${domain} was renewed, manual restart of Home-Assistant is required"
        fi
    done
}

restart_addons() {
    if [ "$(bashio::config 'addons')" != null ]; then
        for addon in $(bashio::config 'addons'); do
            restart_addon ${addon}
        done
    fi
}

restart_addon() {
    msg=$(curl -X POST -sSL -o /dev/null -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/addons/$1/restart)
    if [ $? -ne 0 ] ; then
        bashio::log.error "Error restarting addon ${1}: $msg | jq -r '.message'"
    else
        bashio::log.info "Restarted addon $1"
    fi
}
