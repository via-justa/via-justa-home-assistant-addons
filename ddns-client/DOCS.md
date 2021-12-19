# Home Assistant Add-on: ddns-client

DynDNS client to update dns record(s) with your current IP if your IP is not static

## Installation
1. Navigate in your Home Assistant frontend to Supervisor -> Add-on Store.
2. Add the repository via the 3 dots manue > repositories > enter "https://github.com/via-justa/ddns-client-addon" > select add
2. Find the "ddns-client" add-on and click it.
3. Click on the "INSTALL" button.

## Configuration

Example addon configuration

```yaml
provider: hetzner
key: HETZNER_API_KEY
value: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
records: home-assistant.domain.com
check_interval: 1h
```

### Global configuration settings

**Option:** `records`

List of domains to set and monitor. If setting more than one record, seperate with a comma (`,`) 

**Option:** `check_interval`

Interval to check records status in time format (e.g. 30m, 1h) defauls is every hour (`1h`)

### supported providers configurations

#### Hetzner

From the hetzner DNS control panel at https://dns.hetzner.com go to "API Tokens" and add a personal access token.

```yaml
provider: hetzner
key: HETZNER_API_KEY
value: <hetzner API token>
```

#### Nameceap

```yaml
provider: namecheap
key: `NAMECHEAP_<DOMAIN>_PASSWORD`
value: <namecheap domain password>
```
`<DOMAIN>` is your domain when all `-` and `.` are replaced with underscore (e.g. for home-assistant.domain.com set `NAMECHEAP_HOME_ASSISTANT_DOMAIN_COM_PASSWORD`)

