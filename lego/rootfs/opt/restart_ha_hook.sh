#!/usr/bin/with-contenv bashio

source /opt/functions.sh

restart_addons

msg=$(curl -X POST -sSL -o /dev/null -H "Authorization: Bearer $SUPERVISOR_TOKEN" http://supervisor/core/restart)
if [ $? -ne 0 ] ; then
    bashio::log.error "Error restarting HA core: $msg | jq -r '.message'"
else
    bashio::log.info "Restarted HA core"
fi