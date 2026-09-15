#!/usr/bin/env bash
set -euo pipefail

source "$HOME/family-node-kit/system/lib/bitcoin-runtime.sh"

echo "================================="
echo "   STARTING BITCOIN NODE STACK"
echo "================================="

############################################
# 0. SYSTEM TIME CHECK
############################################

echo "[0/4] Checking system time..."

if ! timedatectl | grep -q "System clock synchronized: yes"; then
    echo
    echo "❌ ERROR: System clock NOT synchronized"
    echo
    echo "Enable NTP with:"
    echo "  sudo systemctl enable --now chronyd"
    exit 1
fi

echo "✔ System clock synchronized"
echo "ℹ Time drift: handled by system NTP"

############################################
# FIRST RUN WARNING
############################################

if [[ ! -f "$HOME/.family-node-kit/.first-run-accepted" ]]; then
    echo
    echo "⚠ WARNING:"
    echo "Initial blockchain sync can take several days (or more)."
    echo "It may download hundreds of GB of data."
    echo "You can safely stop and resume later."
    echo

    read -rp "Type YES to continue: " CONFIRM

    if [[ "$CONFIRM" != "YES" ]]; then
        echo "Aborted."
        exit 0
    fi

    mkdir -p "$HOME/.family-node-kit"
    touch "$HOME/.family-node-kit/.first-run-accepted"
fi

############################################
# 1. FIND BITCOIN INSTALLATION
############################################

BITCOIN_DIR="$(get_bitcoin_dir)" || {
    echo "❌ ERROR: Bitcoin installation not found"
    exit 1
}

BITCOIND="$(get_bitcoind)"
BITCOIN_CLI="$(get_bitcoin_cli)"

BITCOIN_CONF="$HOME/.bitcoin/bitcoin.conf"
RPC_ENV="$HOME/.family-node-kit/env/rpc.env"

############################################
# PREPARE BITCOIN CONFIGURATION
############################################

echo
echo "[1/4] Preparing Bitcoin configuration..."

mkdir -p "$HOME/.bitcoin"
mkdir -p "$(dirname "$RPC_ENV")"

############################################
# Ensure RPC credentials exist
############################################

if [[ ! -f "$RPC_ENV" ]]; then

    echo "Creating RPC credentials..."

    RPC_USER="rpc$(openssl rand -hex 3)"
    RPC_PASS="$(openssl rand -base64 32)"

    cat > "$RPC_ENV" <<EOF_RPC
RPC_USER=$RPC_USER
RPC_PASS=$RPC_PASS
EOF_RPC

    chmod 600 "$RPC_ENV"
fi

# shellcheck disable=SC1090
source "$RPC_ENV"

if [[ -z "${RPC_USER:-}" || -z "${RPC_PASS:-}" ]]; then
    echo "❌ Invalid RPC configuration:"
    echo "   $RPC_ENV"
    exit 1
fi

############################################
# Create bitcoin.conf if missing
############################################

mkdir -p "$(dirname "$BITCOIN_CONF")"
touch "$BITCOIN_CONF"

############################################
# Helper: set or replace config value
############################################

set_conf() {

    local KEY="$1"
    local VALUE="$2"

    sed -i "/^${KEY}=/d" "$BITCOIN_CONF"
    echo "${KEY}=${VALUE}" >> "$BITCOIN_CONF"
}

############################################
# Required settings
############################################

set_conf "server" "1"
set_conf "daemon" "1"

set_conf "txindex" "1"
set_conf "blockfilterindex" "1"

set_conf "rpcuser" "$RPC_USER"
set_conf "rpcpassword" "$RPC_PASS"

set_conf "zmqpubrawblock" "tcp://127.0.0.1:28332"
set_conf "zmqpubrawtx" "tcp://127.0.0.1:28333"

echo "✔ Bitcoin configuration ready"

############################################
# 2. START BITCOIN
############################################

echo "[2/4] Starting Bitcoin node..."

BITCOIN_STARTED=0

if is_bitcoin_running; then
    echo "ℹ Bitcoin already running"
    BITCOIN_STARTED=1
else

    # Bitcoin Core can briefly retain the data-directory lock
    # after a clean shutdown. This can be more noticeable
    # while the node is busy synchronizing.
    #
    # Retry the daemon start instead of failing immediately.

    for i in {1..12}; do

        if "$BITCOIND" -conf="$BITCOIN_CONF" -daemonwait; then
            echo "Bitcoin daemon started"
            BITCOIN_STARTED=1
            break
        fi

        if is_bitcoin_running; then
            echo "✔ Bitcoin daemon started"
            BITCOIN_STARTED=1
            break
        fi

        if [[ "$i" -lt 12 ]]; then
            echo "⏳ Bitcoin start retry... ($i/12)"
            sleep 5
        fi
    done
fi

if [[ "$BITCOIN_STARTED" -ne 1 ]]; then
    echo
    echo "❌ ERROR: Bitcoin daemon could not be started"
    echo "ℹ Bitcoin data directory may still be locked."
    exit 1
fi

echo "Waiting Bitcoin RPC..."

READY=0

for i in {1..60}; do
    if "$BITCOIN_CLI" -conf="$BITCOIN_CONF" getblockchaininfo >/dev/null 2>&1; then
        READY=1
        break
    fi

    echo "Waiting RPC... ($i/60)"
    sleep 2
done

if [[ "$READY" -ne 1 ]]; then
    echo "❌ ERROR: Bitcoin RPC not responding"
    exit 1
fi

echo "✔ Bitcoin ready"

echo For the complete Bitcoin Core update procedure, read:
echo
echo  DOCUMENTATIONS/UPDATE-BITCOIN-CORE.md

############################################
# BITCOIN SYNC STATUS
############################################

echo "[STATUS] Bitcoin sync progress:"

SYNC_PROGRESS=$(
    "$BITCOIN_CLI" -conf="$BITCOIN_CONF" \
    getblockchaininfo 2>/dev/null |
    jq -r '.verificationprogress'
)

if [[ -n "$SYNC_PROGRESS" ]]; then
    PERCENT=$(awk "BEGIN { printf \"%.2f\", $SYNC_PROGRESS * 100 }")
    echo "✔ Bitcoin sync: ${PERCENT}%"
else
    echo "ℹ Bitcoin sync progress unavailable"
fi

############################################
# 3. START FULCRUM
############################################

echo "[3/4] Starting Fulcrum..."
echo "ℹ This step may take a long time during initial sync"
echo "ℹ Port 50001 will open only after indexing"

if [[ -x "$HOME/family-node-kit/system/bin/start-fulcrum.sh" ]]; then
    bash "$HOME/family-node-kit/system/bin/start-fulcrum.sh"
else
    echo "❌ ERROR: start-fulcrum.sh not found"
    exit 1
fi

echo "✔ Fulcrum launched (background indexing active)"

############################################
# COMPLETE
############################################

echo
echo "================================="
echo " NODE STACK READY"
echo "================================="
echo
echo "Bitcoin data:"
echo "  ~/.bitcoin"
echo
echo "Fulcrum data:"
echo "  ~/.fulcrum"
echo
echo "To stop Bitcoin and Fulcrum:"
echo "  STOP) Stop Bitcoin Services"
echo
echo "================================="
