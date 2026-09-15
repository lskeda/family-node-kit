#!/usr/bin/env bash
set -euo pipefail

source "$HOME/family-node-kit/system/lib/bitcoin-runtime.sh"

LOG="$HOME/.local/share/bitcoin-service.log"

mkdir -p "$(dirname "$LOG")"

echo "$(date '+%Y-%m-%d %H:%M:%S') === Stopping Bitcoin services ===" \
    | tee -a "$LOG"

############################################
# STOP BITCOIN FIRST
############################################

BITCOIN_CLI="$(get_bitcoin_cli)" || {
    echo "ERROR: Bitcoin installation not found." | tee -a "$LOG"
    exit 1
}

if is_bitcoin_running; then

    echo "Stopping Bitcoin node cleanly..." | tee -a "$LOG"

    "$BITCOIN_CLI" -conf="$HOME/.bitcoin/bitcoin.conf" stop \
        2>&1 | tee -a "$LOG"

    echo "Waiting for Bitcoin node to exit..." | tee -a "$LOG"

    BITCOIN_STOPPED=0

    for i in {1..60}; do
        if ! is_bitcoin_running; then
            BITCOIN_STOPPED=1
            break
        fi
        sleep 1
    done

    if [[ "$BITCOIN_STOPPED" -ne 1 ]]; then
        echo "❌ ERROR: Bitcoin node did not stop within 60 seconds." \
            | tee -a "$LOG"
        echo "ℹ Bitcoin node was NOT killed." | tee -a "$LOG"
        echo "ℹ Services stop aborted." | tee -a "$LOG"
        exit 1
    fi

    echo "✔ Bitcoin node stopped." | tee -a "$LOG"

    ############################################
    # ALLOW CLEAN SHUTDOWN TO SETTLE
    ############################################

    echo "Waiting for Bitcoin shutdown to settle..." | tee -a "$LOG"

    sleep 2

else
    echo "Bitcoin node not running." | tee -a "$LOG"
fi

############################################
# STOP FULCRUM
############################################

if podman ps --format '{{.Names}}' | grep -q '^fulcrum$'; then

    echo "Stopping Fulcrum container..." | tee -a "$LOG"

    podman stop fulcrum 2>&1 | tee -a "$LOG"

else
    echo "Fulcrum container not running." | tee -a "$LOG"
fi

############################################
# STOP TOR
############################################

if podman ps --format '{{.Names}}' | grep -q '^tor-electrum$'; then

    echo "Stopping Tor Electrum service..." | tee -a "$LOG"

    podman rm -f tor-electrum 2>&1 | tee -a "$LOG"

else
    echo "Tor Electrum not running." | tee -a "$LOG"
fi

echo "$(date '+%Y-%m-%d %H:%M:%S') Bitcoin services stopped." \
    | tee -a "$LOG"

exit 0
