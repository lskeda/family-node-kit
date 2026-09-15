#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo "    FAMILY NODE RESET"
echo "================================="

############################################
# 0. SYSTEM TIME CHECK
############################################

echo "[0/4] Checking system time..."

if ! timedatectl | grep -q "System clock synchronized: yes"; then
    echo "❌ ERROR: System clock NOT synchronized"
    echo "Enable NTP first:"
    echo "  sudo systemctl enable --now chronyd"
    exit 1
fi

echo "✔ System clock synchronized"

############################################
# 1. RESOLVE BITCOIN INSTALLATION
############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/bitcoin-runtime.sh"

BITCOIN_DIR="$(get_bitcoin_dir)" || {
    echo "❌ ERROR: Bitcoin directory not found"
    exit 1
}

BITCOIN_CLI="$(get_bitcoin_cli)"
BITCOIN_CONF="$HOME/.bitcoin/bitcoin.conf"

echo "[1/4] Bitcoin installation:"
echo "  $BITCOIN_DIR"

############################################
# 2. STOP CONTAINERS
############################################

echo "[2/4] Stopping containers..."

for c in fulcrum tor tor-electrum; do
    podman stop "$c" 2>/dev/null || true
    podman rm "$c" 2>/dev/null || true
done

echo "✔ Containers cleaned"

############################################
# 3. STOP BITCOIN CLEANLY
############################################

echo "[3/4] Stopping Bitcoin..."

if pgrep -x bitcoind >/dev/null; then

    echo "Requesting graceful shutdown..."

    "$BITCOIN_CLI" -conf="$BITCOIN_CONF" stop 2>/dev/null || true

    for i in {1..40}; do
        if ! pgrep -x bitcoind >/dev/null; then
            break
        fi
        sleep 1
    done
fi

############################################
# HARD STOP FALLBACK
############################################

if pgrep -x bitcoind >/dev/null; then
    echo "⚠ Graceful shutdown timeout"
    echo "⚠ Sending SIGTERM..."

    pkill -TERM bitcoind || true
    sleep 5
fi

if pgrep -x bitcoind >/dev/null; then
    echo "⚠ Sending SIGKILL..."
    pkill -KILL bitcoind || true
    sleep 2
fi

############################################
# 4. FINAL VERIFICATION
############################################

echo "[4/4] Final verification..."

FAIL=0

if pgrep -x bitcoind >/dev/null; then
    echo "❌ Bitcoin still running"
    FAIL=1
else
    echo "✔ Bitcoin stopped"
fi

if podman ps --format '{{.Names}}' | grep -Eq '^(fulcrum|tor|tor-electrum)$'; then
    echo "❌ Some containers still running"
    FAIL=1
else
    echo "✔ Containers stopped"
fi

echo
echo "================================="

if [[ "$FAIL" -eq 0 ]]; then
    echo " RESET COMPLETE"
else
    echo " RESET COMPLETED WITH WARNINGS"
fi

echo "================================="
echo

echo "Runtime reset:"
echo "  ✔ Bitcoin stopped"
echo "  ✔ Fulcrum container removed"
echo "  ✔ Tor container removed"
echo

echo "Blockchain data preserved:"
echo "  ✔ ~/.bitcoin"
echo "  ✔ ~/.fulcrum"
echo

echo "Note:"
echo
echo "The next start will recreate"
echo "the required containers."
echo
echo "Until Fulcrum is started again,"
echo "the Health Report may show:"
echo
echo "  🟡 Partially verified"
echo
echo "This is expected."
echo

echo "Next Step:"
echo
echo "  1) Start Bitcoin + Fulcrum"
echo
echo "================================="
