#!/usr/bin/env bash

############################################
#
# Family Node Kit
#
# Shared Library
# Tor runtime helpers
#
# Functions only.
# No output.
# No side effects.
#
############################################

#
# Returns:
#   0 = Tor is running
#   1 = Tor is NOT running
#
is_tor_running() {
    podman ps --format '{{.Names}}' |
        grep -qx "$(get_tor_container)"
}

#
# Returns how Tor is installed.
#
get_tor_source() {
    echo "Podman"
}

#
# Returns the Tor runtime.
#
get_tor_runtime() {
    echo "Podman Container"
}

#
# Returns the Tor container image.
#
get_tor_image() {
    echo "docker.io/osminogin/tor-simple:latest"
}

#
# Returns the Tor container name.
#
get_tor_container() {
    echo "tor-electrum"
}

#
# Returns the Tor data directory.
#
get_tor_data_dir() {
    echo "$HOME/.tor-electrum"
}

#
# Returns the torrc configuration file.
#
get_tor_torrc() {
    echo "$HOME/.config/tor-electrum/torrc"
}

#
# Returns the local SOCKS proxy endpoint.
#
get_tor_socks_proxy() {
    echo "127.0.0.1:9050"
}

#
# Returns the saved Onion hostname file.
#
get_tor_hostname_file() {
    echo "$HOME/.tor-electrum/onion.txt"
}

#
# Returns the Onion service port.
#
get_tor_hidden_service_port() {
    echo "50002"
}

#
# Returns the Podman image digest.
#
get_tor_image_digest() {
    podman image inspect "$(get_tor_image)" \
        --format '{{.Digest}}' 2>/dev/null
}

#
# Returns the published Onion address.
#
get_tor_onion_address() {

    local file

    file="$(get_tor_hostname_file)"

    [[ -r "$file" ]] || return 1

    cat "$file"
}

#
# Returns the official project URL.
#
get_tor_project_url() {
    echo "https://www.torproject.org"
}
