#!/usr/bin/env bash

############################################
#
# Family Node Kit
#
# Shared Library
# Fulcrum runtime helpers
#
# Functions only.
# No output.
# No side effects.
#
############################################

#
# Returns:
#   0 = Fulcrum is running
#   1 = Fulcrum is NOT running
#
is_fulcrum_running() {
    podman ps --format '{{.Names}}' |
        grep -qx "$(get_fulcrum_container)"
}

#
# Returns:
#   0 = Fulcrum image is installed locally
#   1 = Fulcrum image is NOT installed
#
is_fulcrum_installed() {
    podman image exists "$(get_fulcrum_image)" >/dev/null 2>&1
}

#
# Returns how Fulcrum is installed.
#
get_fulcrum_source() {
    echo "Podman"
}

#
# Returns the Fulcrum runtime.
#
get_fulcrum_runtime() {
    echo "Podman Container"
}

#
# Returns the Fulcrum container image.
#
get_fulcrum_image() {
    podman images \
        --format '{{.Repository}}:{{.Tag}}' |
        grep -E '^docker\.io/cculianu/fulcrum:v[0-9]+\.[0-9]+\.[0-9]+$' |
        sort -V |
        tail -n1
}

#
# Returns the Fulcrum container name.
#
get_fulcrum_container() {
    echo "fulcrum"
}

#
# Returns the Fulcrum data directory.
#
get_fulcrum_data_dir() {
    echo "$HOME/.fulcrum"
}

#
# Returns the OCI image digest.
#
get_fulcrum_image_digest() {
    podman image inspect "$(get_fulcrum_image)" \
        --format '{{.Digest}}' 2>/dev/null
}

#
# Returns the container log line containing the version.
#
get_fulcrum_banner() {
    local logs

    logs="$(podman logs "$(get_fulcrum_container)" 2>/dev/null)"

    printf '%s\n' "$logs" | awk '/Fulcrum / { print; exit }'
}

#
# Returns the running version.
#
get_fulcrum_version() {
    get_fulcrum_banner |
        sed -E 's/.*Fulcrum ([0-9.]+).*/\1/'
}

#
# Returns the running release string.
#
get_fulcrum_release() {
    get_fulcrum_banner |
        sed -E 's/.*Release ([^)]+).*/\1/'
}

#
# Returns the official project URL.
#
get_fulcrum_project_url() {
    echo "https://github.com/cculianu/Fulcrum"
}
