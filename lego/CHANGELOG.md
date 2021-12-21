<!-- https://developers.home-assistant.io/docs/add-ons/presentation#keeping-a-changelog -->
## 0.2.0

### New Features

- Add `--renew-hook` to automatically restart `Home-Assistant core` when renewing certificate.

### Improvements

- Better check for specific domain certificate, issue each domain severalty.
- Remove config option `interval` in favor of running in specific time. 
- Change port for the `http challenge` from `80` to high port `8091` to free port `80` for other services.
- Change default renew time to `30` days to reduce the renew frequency

### Bug Fix

- Fix command selection done once on addon start.

### Others

- Code cleanup

## 0.1.3

- fix wrong log statement
- enable ingress

## 0.1.2

- Publish docker images instead of local build

## 0.1.0

- First version
