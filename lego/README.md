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

[Logo](https://github.com/go-acme/lego) is a Let's Encrypt client and ACME library written in Go.

## Features
- Create/renew certificates for multiple domains
- supports both ACME HTTP and DNS-01 challenges with [~100 different DNS providers](https://go-acme.github.io/lego/dns/)
- Auto restart of Home-Assistant on certificate renewal
- HTTP challenge using high port to free port 80 for other services.

**The addon is still under development so configuration and functionality changes my be introduced!**
