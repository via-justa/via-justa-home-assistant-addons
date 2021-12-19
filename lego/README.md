# Home Assistant Add-on: Lego

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg

Let's Encrypt client and ACME library written in Go.

Supports both HTTP and DNS-01 challanges with a long list of providers

## Lego vs The built-in Let's Encrypt addon

While the built-in [Let's Encrypt addon](https://github.com/home-assistant/addons/tree/master/letsencrypt) is good and well for HTTP challange, when it comes to DNS-01 challange it supports only very limitaed number of DNS providers (19 as of end of 2021) while [Lego](https://github.com/go-acme/lego) supports 98(!!) different DNS providers. If that's not enough to convince you, the built-in addon does not "watch the certificate and renew it automatically while this addon does.