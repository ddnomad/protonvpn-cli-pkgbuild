protonvpn-cli-pkgbuild
======================
[![Build Status](https://travis-ci.org/ddnomad/protonvpn-cli-pkgbuild.svg?branch=master)](https://travis-ci.org/ddnomad/protonvpn-cli-pkgbuild) [![license](https://img.shields.io/github/license/ddnomad/protonvpn-cli-pkgbuild.svg)](https://github.com/ddnomad/protonvpn-cli-pkgbuild)

> **NOTE**: This is a package build for a deprecated version of ProtonVPN CLI. For most people it is worth to switch to a [new version of CLI](https://github.com/ProtonVPN/protonvpn-cli-ng) and a corresponding [AUR package](https://aur.archlinux.org/packages/protonvpn-cli-ng/).

PKGBUILD to install [protonvpn-cli](https://github.com/ProtonVPN/protonvpn-cli) on your Arch Linux host. Should be up on AUR
as well (obviously).

Travis build is scheduled to fire once per week so hopefully dd will be able to know when thing went nasty.

Manual Build
------------
Just in case somebody into manually building the thing here is a rundown:
```
$ git clone git@github.com:ddnomad/protonvpn-cli-pkgbuild.git
$ cd protonvpn-cli-pkgbuild
$ ./entrypoint.sh --test
```

Yeah, strangely enough test script will actually install the package on your host.
