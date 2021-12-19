# Home Assistant Add-on: Lego

Let's Encrypt client and ACME library written in Go.

## Installation
1. Navigate in your Home Assistant frontend to Supervisor -> Add-on Store.
2. Add the repository via the 3 dots manue > repositories > enter "https://github.com/via-justa/via-justa-home-assistant-addons" > select add
2. Find the "lego" add-on and click it.
3. Click on the "INSTALL" button.

## Configuration

Example addon configuration

```yaml
provider: hetzner
domains:
  - home-assistant.domain.com
email: me@gmail.com
env_vars:
  - name: HETZNER_API_KEY
    value: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
challange: dns
```

### Global configuration settings

**Option:** `domains` (required)

List of domains to generate certificate for.
can also be wildcard domain (e.g. `*.domain.com`)

**Option:** `email` (required)

Email Let's Encrypt register the certificates to

**Option:** `provider` (required for DNS challange)

Name of the provider for the DNS challange.
List of available providers can be found [here](https://go-acme.github.io/lego/dns/)

**Option:** `env_vars` (required for DNS challange)

List of `name` and `value` keys where `name` is the environment variable name and `value` is its value.

A full providers configuration details can be found [here](https://go-acme.github.io/lego/dns/)

**Option:** `challange` (optional)

What type of challange should be used. Available options are `http` and `dns`

*default: `http`*

**Option:** `renew_threshold` (optional)

Number of days before the certificate expires to renew it.

*default: `45`*

**Option:** `interval` (optional)

Interval to check certificate validity.

*default: `1d`*

**Option:** `log_level` (optional)

Log level to use. Options are `trace`, `debug`, `info`, `notice`, `warning`, `error`, and `fatal`

*default: `info`*