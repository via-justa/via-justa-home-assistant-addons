# Home Assistant Add-on: Lego

[Logo](https://github.com/go-acme/lego) is a Let's Encrypt client and ACME library written in Go.

## Installation
1. Navigate in your Home Assistant frontend to Supervisor -> Add-on Store.
2. Add the repository via the 3 dots menu > repositories > enter "https://github.com/via-justa/via-justa-home-assistant-addons" > select add
2. Find the "lego" add-on and click it.
3. Click on the "INSTALL" button.

## Configuration

### Challenges options

#### HTTP challenge
HTTP challenge (also known as HTTP-01 challenge) works by telling Let's Encrypt the address of the server it needs to create a certificate for. 
In turn Let's Encrypt is trying to query a file served on that server with an authentication token.

That means you need your Home-Assistant server needs to be exposed to the internet with port 80.
While the Addon is exposing the service by default with port `8091` (can be overridden) to allow you to run a different service on port `80` on Home Assistant, you need to add a redirect rule to redirect port `80` on your router to the configured Lego port.

If you cannot open ports on the router or do not want to, please use the DNS challenge option.

For more information you can read the [Let's Encrypt HTTP challenge documentation](https://letsencrypt.org/docs/challenge-types/#http-01-challenge)

#### Example addon configuration for HTTP challenge

```yaml
domains:
  - home-assistant.domain.com
email: me@gmail.com
env_vars:
  - name: ''
    value: ''
```

#### DNS Challenge
DNS challenge (also known as DNS-01 challenge) works by pointing Let's Encrypt to authenticate against a publicly available DNS record. 
For DNS challenge to work, you need to have access to a managed DNS provider where you can generate an API token that can create new records. In addition, a DNS record with the requested domain name must exist before generating the certificate.

That means you can create generate a certificate on the Home-Assistant server without exposing any port to the world.

For more information you can read the [Let's Encrypt DNS challenge documentation](https://letsencrypt.org/docs/challenge-types/#dns-01-challenge)

**Tip:** If using DNS challenge, the port mapping under the `Network` section of the configuration can be removed.

#### Example addon configuration for DNS challenge

```yaml
provider: hetzner
domains:
  - home-assistant.domain.com
email: me@gmail.com
env_vars:
  - name: HETZNER_API_KEY
    value: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
challenge: dns
```

### Global configuration settings

**Option:** `domains` (required)

List of domains to generate certificate for.
can also be wildcard domain (e.g. `*.domain.com`)
You can create a certificate with multiple SANs by comma-separating them on a single line (e.g. `*.domain.com,host.domain.com`)

**Option:** `email` (required)

Email Let's Encrypt register the certificates to

**Option:** `restart` (required)

Should Home-Assistant core and optionally the given addons be restarted on certificate renewal

*default: `true`*

**Option:** `provider` (required for DNS challenge)

Name of the provider for the DNS challenge.
List of available providers can be found [here](https://go-acme.github.io/lego/dns/)

**Option:** `env_vars` (required for DNS challenge)

List of `name` and `value` keys where `name` is the environment variable name and `value` is its value.

A full providers configuration details can be found [here](https://go-acme.github.io/lego/dns/)

**Option:** `challenge` (optional)

What type of challenge should be used. Available options are `http` and `dns`

*default: `http`*

**Option:** `renew_threshold` (optional)

Number of days before the certificate expires to renew it.

*default: `30`*

**Option:** `check_time` (optional)

Time of day to run the renewal.

*default: `04:00`*

**Option:** `addons` (optional)

List of addon IDs to restart when the certificate is renewed.
To get the Addon ID go to the installed addon page and extract it from the URL of the page
dor example the id of the installed `lego` here is `7ca25b85_lego`
```
https://ha.domain.com:8123/hassio/addon/7ca25b85_lego/config
```

*default: `''`*

**Option:** `log_level` (optional)

Log level to use. Options are `trace`, `debug`, `info`, `notice`, `warning`, `error`, and `fatal`

*default: `info`*
