#!/usr/bin/env bash
#
###############################################################################
# Title:       entrypoint.sh
# Description: Test protonvpn-cli package installation
# Usage:       Specify as Docker entrypoint. Options supported:
#                  --bypass    Execute whatever command is following
#                  --devenv    Start a development environment
# Version:     0.0.1
###############################################################################
set -euo pipefail


readonly DOCKER_USER='test'


###############################################################################
# Setup Vi CLI mode by placing a corresponding .bashrc in /root/
#
# Return:
#   0 - Setup was successful
#   1 - Otherwise (may terminate as well)
###############################################################################
function setup_vi_mode {
    echo -e 'set -o vi\nbind -m vi-insert "\C-l":clear-screen' \
        > /home/"${DOCKER_USER}"/.bashrc
}


###############################################################################
# Test protonvpn-cli package installation
#
# Return:
#   0 - Installed successfully
#   1 - Otherwise (may terminate as well)
###############################################################################
function test_buildpkg {
    echo '[i] Installing the package'
    makepkg -s -L --noconfirm ./PKGBUILD
    sudo pacman -U --noconfirm protonvpn-cli-*.tar.xz
    echo '[+] Done'

    echo '[i] Testing whether the executable is in PATH and works'
    if ! (which protonvpn-cli && which pvpn && pvpn --help) 1>/dev/null; then
        echo '[-] Error: package was installed incorrectly'
        return 1
    fi

    echo '[+] All checks passed: OK'
}


###############################################################################
# Main flow
###############################################################################
# Make sure arguments structure is correct
if test "$#" -lt 1; then
    echo '[-] Bad arguments. Terminating.'
    exit 1
fi

# Resolve CLI arguments
if test "$1" = '--bypass'; then
    # Setup Vi CLI mode if host user is ddnomad
    if test "${HOST_USER}" = 'ddnomad'; then
        echo '[i] Detected ddnomad. Setting up Vi mode.'
        setup_vi_mode
        echo '[+] Done'
    fi

    echo '[i] Bypassing input command'
    shift
    exec "$@"

elif test "$1" = '--test'; then
    echo '[i] Testing package installation'
    test_buildpkg

else
    echo "[-] Unknown argument: $1"
    exit 1
fi

