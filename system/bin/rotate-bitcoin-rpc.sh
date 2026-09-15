#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/family-node-kit/system/bin"

CONFIG="$HOME/.family-node-kit/env/rpc.env"

source "$HOME/family-node-kit/system/lib/bitcoin-runtime.sh"

echo "Rotating Bitcoin RPC..."

# -----------------------------
# Load config
# -----------------------------

if [[ ! -f "$CONFIG" ]]; then
    echo "❌ Missing RPC configuration:"
    echo "   $CONFIG"
    exit 1
fi

source "$CONFIG"

# -----------------------------
# STOP everything first
# -----------------------------

echo "Stopping Bitcoin services..."
"$BASE/stop-bitcoin-services.sh"

# -----------------------------
# REMOVE OLD FULCRUM CONTAINER
# -----------------------------

echo "Removing existing Fulcrum container..."

if podman container exists fulcrum; then
    podman rm fulcrum
    echo "✔ Existing Fulcrum container removed"
else
    echo "ℹ No existing Fulcrum container found"
fi

# -----------------------------
# Generate new password
# -----------------------------

RPC_PASS=$(openssl rand -base64 32)

# -----------------------------
# Update config
# -----------------------------

cat > "$CONFIG" <<EOF_RPC
RPC_USER=$RPC_USER
RPC_PASS=$RPC_PASS
EOF_RPC

chmod 600 "$CONFIG"

echo "✔ New RPC credentials generated"

# -----------------------------
# RESTART clean system
# -----------------------------

echo
echo "Restarting full stack..."

"$BASE/start-bitcoin-services.sh"

# -----------------------------
# STRONG POST-ROTATION VERIFY
# -----------------------------

echo
echo "================================="
echo " VERIFYING RPC ROTATION"
echo "================================="

# -----------------------------
# Verify Bitcoin RPC
# -----------------------------

BITCOIN_CONF="$HOME/.bitcoin/bitcoin.conf"
BITCOIN_CLI="$(get_bitcoin_cli)"

echo
echo "[1/2] Verifying Bitcoin RPC..."

BITCOIN_READY=0

for i in {1..30}; do
    if "$BITCOIN_CLI" -conf="$BITCOIN_CONF" \
        getblockchaininfo >/dev/null 2>&1; then
        BITCOIN_READY=1
        break
    fi

    echo "⏳ Bitcoin RPC not ready yet... ($i/30)"
    sleep 2
done

if [[ "$BITCOIN_READY" -ne 1 ]]; then
    echo
    echo "❌ RPC rotation incomplete"
    echo
    echo "Bitcoin RPC: NOT READY"
    echo "Fulcrum:     UNKNOWN"
    echo
    echo "The new RPC credentials were installed,"
    echo "but Bitcoin RPC did not become ready."
    exit 1
fi

echo "✔ Bitcoin RPC READY"

# -----------------------------
# Verify Fulcrum
# -----------------------------

echo
echo "[2/2] Verifying Fulcrum..."

FULCRUM_READY=0

# Special RPC-rotation verification window:
# 120 attempts x 5 seconds = 10 minutes.

for i in {1..120}; do

    if podman ps --format '{{.Names}}' |
        grep -qx "fulcrum"; then

        if timeout 1 bash -c \
            "echo > /dev/tcp/127.0.0.1/50001" \
            2>/dev/null; then

            FULCRUM_READY=1
            break
        fi
    fi

    ELAPSED=$((i * 5))

    echo "⏳ Fulcrum not ready yet... (${ELAPSED}s/600s)"
    sleep 5
done

if [[ "$FULCRUM_READY" -ne 1 ]]; then
    echo
    echo "❌ RPC rotation incomplete"
    echo
    echo "Bitcoin RPC: READY"
    echo "Fulcrum:     NOT READY"
    echo
    echo "Fulcrum may still be indexing."
    echo "The new RPC credentials have been installed."
    echo
    echo "Check Fulcrum with:"
    echo "  podman logs -f fulcrum"
    echo
    echo "Check port 50001 with:"
    echo "  ss -lnt | grep 50001"
    exit 1
fi

echo "✔ Fulcrum READY (port 50001 open)"

# -----------------------------
# FINAL RESULT
# -----------------------------

echo
echo "================================="
echo " RPC ROTATION COMPLETE"
echo "================================="
echo
echo "✔ Bitcoin RPC verified"
echo "✔ Fulcrum verified"
echo "✔ New RPC credentials active"
echo
echo "================================="
