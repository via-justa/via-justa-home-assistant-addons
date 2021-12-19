#!/usr/bin/with-contenv bashio
CONFIG_PATH=/data/options.json

declare provider
declare env_var_name
declare env_var_value
declare records
declare check_interval

provider=$(bashio::config 'provider')
env_var_name=$(bashio::config 'key')
env_var_value=$(bashio::config 'value')
records=$(bashio::config 'records')
check_interval=$(bashio::config 'check_interval')

export $(echo ${env_var_name^^})=$env_var_value

echo "Starting DNS records monitoring"

ddns-client -p $provider -d $records -i $check_interval