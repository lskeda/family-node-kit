#!/usr/bin/env bash
set -euo pipefail

source "$HOME/family-node-kit/system/lib/bitcoin-runtime.sh"
source "$HOME/family-node-kit/system/lib/fulcrum-runtime.sh"

LOG="$HOME/.local/share/bitcoin-service.log"
mkdir -p "$(dirname "$LOG")"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG"
}

log "=== Stopping Bitcoin services ==="

# Check Podman before attempting any service shutdown.
if ! command -v podman >/dev/null 2>&1 || ! podman info >/dev/null 2>&1; then
    log "ERROR: Podman is unavailable or not responding."
    log "Shutdown aborted before stopping services."
    exit 1
fi

############################################
# STOP FULCRUM FIRST
############################################

FULCRUM_NAME="$(get_fulcrum_container)"

if podman container exists "$FULCRUM_NAME" 2>/dev/null; then
    FULCRUM_STATE="$(podman inspect --format '{{.State.Status}}' "$FULCRUM_NAME" 2>/dev/null)" || {
        log "ERROR: Cannot inspect Fulcrum container state."
        log "Bitcoin Core will remain running."
        exit 1
    }

    if [[ "$FULCRUM_STATE" == "running" ]]; then
        log "Sending SIGTERM to Fulcrum; waiting up to 300 seconds..."

        if ! podman kill --signal TERM "$FULCRUM_NAME" 2>&1 | tee -a "$LOG"; then
            log "ERROR: Could not send SIGTERM to Fulcrum."
            log "Bitcoin Core will remain running."
            exit 1
        fi

        FULCRUM_STOPPED=0

        for i in {1..300}; do
            FULCRUM_STATE="$(podman inspect --format '{{.State.Status}}' "$FULCRUM_NAME" 2>/dev/null)" || {
                log "ERROR: Cannot verify Fulcrum's final state."
                log "Bitcoin Core will remain running."
                exit 1
            }

            if [[ "$FULCRUM_STATE" == "exited" || "$FULCRUM_STATE" == "stopped" ]]; then
                FULCRUM_STOPPED=1
                break
            fi

            sleep 1
        done

        if [[ "$FULCRUM_STOPPED" -ne 1 ]]; then
            log "ERROR: Fulcrum did not exit within 300 seconds (state: $FULCRUM_STATE)."
            log "Bitcoin Core will remain running."
            exit 1
        fi
    elif [[ "$FULCRUM_STATE" == "exited" || "$FULCRUM_STATE" == "stopped" || "$FULCRUM_STATE" == "created" ]]; then
        log "Fulcrum container is already stopped (state: $FULCRUM_STATE)."
    else
        log "ERROR: Unexpected Fulcrum state: $FULCRUM_STATE."
        log "Bitcoin Core will remain running."
        exit 1
    fi

    log "Fulcrum container has exited."
else
    log "Fulcrum container not found; nothing to stop."
fi

############################################
# STOP BITCOIN SECOND
############################################

BITCOIN_CLI="$(get_bitcoin_cli)" || {
    log "ERROR: Bitcoin installation not found."
    exit 1
}

if is_bitcoin_running; then
    log "Stopping Bitcoin node cleanly..."

    "$BITCOIN_CLI" -conf="$HOME/.bitcoin/bitcoin.conf" stop \
        2>&1 | tee -a "$LOG"

    log "Waiting for Bitcoin node to exit..."

    BITCOIN_STOPPED=0

    for i in {1..60}; do
        if ! is_bitcoin_running; then
            BITCOIN_STOPPED=1
            break
        fi
        sleep 1
    done

    if [[ "$BITCOIN_STOPPED" -ne 1 ]]; then
        log "ERROR: Bitcoin node did not stop within 60 seconds."
        log "Bitcoin node was not killed."
        exit 1
    fi

    log "Bitcoin node stopped."
else
    log "Bitcoin node not running."
fi

############################################
# STOP TOR LAST
############################################

if podman ps --format '{{.Names}}' | grep -qx 'tor-electrum'; then
    log "Stopping Tor Electrum service..."

    if ! podman stop --time 30 tor-electrum 2>&1 | tee -a "$LOG"; then
        log "ERROR: Could not stop Tor Electrum."
        exit 1
    fi
else
    log "Tor Electrum not running."
fi

log "Bitcoin services stopped."
exit 0
