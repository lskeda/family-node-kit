#!/usr/bin/env bash

############################################
#
# Family Node Kit
#
# Shared Library
# Bitcoin runtime helpers
#
# Functions only.
# No output.
# No side effects.
#
############################################

#
# Returns:
#   0 = Bitcoin is running
#   1 = Bitcoin is NOT running
#
is_bitcoin_running() {
    pgrep -x bitcoind >/dev/null 2>&1
}

#
# Returns the Bitcoin installation directory.
#
get_bitcoin_dir() {
    local dir="$HOME/bitcoin"

    [[ -d "$dir" ]] || return 1
    [[ -x "$dir/bin/bitcoind" ]] || return 1
    [[ -x "$dir/bin/bitcoin-cli" ]] || return 1

    printf '%s\n' "$dir"
}

#
# Returns the full path to bitcoind.
#
get_bitcoind() {
    printf '%s\n' "$(get_bitcoin_dir)/bin/bitcoind"
}

#
# Returns the full path to bitcoin-cli.
#
get_bitcoin_cli() {
    printf '%s\n' "$(get_bitcoin_dir)/bin/bitcoin-cli"
}

#
# Returns the Bitcoin node implementation.
#
get_bitcoin_name() {
    printf '%s\n' "Core"
}

#
# Returns the installed Bitcoin version.
#
get_bitcoin_version() {
    local bitcoind
    bitcoind="$(get_bitcoind)"

    [[ -x "$bitcoind" ]] || return 1

    "$bitcoind" --version |
        head -n1 |
        sed -n 's/.*version v\([^ ]*\).*/\1/p'
}

#
# Returns the Bitcoin data directory.
#
get_bitcoin_data_dir() {
    printf '%s\n' "$HOME/.bitcoin"
}

#
# Returns the runtime type.
#
get_bitcoin_runtime() {
    printf '%s\n' "Native Binary"
}

#
# Returns the installation source.
#
get_bitcoin_source() {
    printf '%s\n' "Local Installation"
}

#
# Returns the executable path.
#
get_bitcoind_path() {
    get_bitcoind
}
