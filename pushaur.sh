#!/usr/bin/env bash
#
###############################################################################
# Title:       pushaur.sh
# Description: Push current version of PKGBUILD to AUR
# Usage:       Run and see whether you have my private key
# Version:     0.0.1
###############################################################################
set -euo pipefail

readonly INFO_EXEC_NAME="$(basename "$0")"
readonly INFO_BASE_DIR="$(pwd)"

readonly MSG_HELP="$(cat <<EOF
Usage: "${INFO_EXEC_NAME}" REMOTE TEMPDIR

OPTIONS
    -h          Print this help message and exit

PARAMETERS
    REMOTE      AUR remote to which to push the package
    TEMPDIR     Temporary directory to use for setup
EOF
)"


function push_to_aur {
    local aur_remote
    local temp_dir
    local new_version

    aur_remote="$1"
    temp_dir="$2"
    new_version="$(date +%s)"

    echo "[i] Bumping a package version to ${new_version}"
    sed -i 's@^\(pkgver=\)\([0-9]\+\)$@\1'"${new_version}"'@' ./PKGBUILD

    echo '[i] Generating commit message'
    local commit_msg
    commit_msg="Commit details: $(
        git remote get-url --push origin | \
        sed -n 's|^git@\(github.com\):\(.\+\).git$|https://\1/\2|p'
    )/tree/$(git rev-parse HEAD)"

    echo '[i] Setting up a temporary repository'
    mkdir -p "${temp_dir}"
    cd "${temp_dir}"

    git init
    git remote add origin "${aur_remote}"
    git pull origin master

    if ! test -f "${INFO_BASE_DIR}/PKGBUILD"; then
        echo '[-] Failed to locate PKGBUILD in the current directory'
    fi

    cp "${INFO_BASE_DIR}/PKGBUILD" "${temp_dir}"
    makepkg --printsrcinfo > .SRCINFO

    echo '[i] Pushing the package to AUR'
    git add ./PKGBUILD ./.SRCINFO
    git commit -m "${commit_msg}"
    git push origin master

    echo '[i] Cleaning up'
    cd "${INFO_BASE_DIR}"
    rm -rf "${temp_dir}"
}


function main {
    if test "$#" -lt 1; then
        echo '[-] Bad input arguments'
        exit 1
    fi

    if test "$1" == '-h'; then
        echo "${MSG_HELP}"
        exit 0
    fi

    if test "$#" -lt 2; then
        echo '[-] Bad input arguments'
        exit 1
    fi

    push_to_aur "$@"
    echo '[+] Done'
}


main "$@"
