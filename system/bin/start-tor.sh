#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo " Start Tor + External wallet"
echo "================================="

############################################
# 1. SYSTEM TIME CHECK
############################################

echo "[1/3] Checking system time..."

if ! timedatectl | grep -q "System clock synchronized: yes"; then
    echo "❌ ERROR: System clock NOT synchronized"
    exit 1
fi

echo "✔ System clock synchronized"

############################################
# 2. START TOR (ROBUST MODE)
############################################

echo "[2/3] Starting Tor service..."

TOR_NAME="tor-electrum"
TOR_IMAGE="docker.io/osminogin/tor-simple:latest"

TOR_DATA="$HOME/.tor-electrum/data"
TORRC_FILE="$HOME/.config/tor-electrum/torrc"

# CLEAN STATE (IMPORTANT ORDER FIX)
podman stop "$TOR_NAME" 2>/dev/null || true
podman rm "$TOR_NAME" 2>/dev/null || true

mkdir -p "$TOR_DATA"
chmod 700 "$TOR_DATA"

mkdir -p "$(dirname "$TORRC_FILE")"

cat > "$TORRC_FILE" <<EOF
HiddenServiceDir /data/hidden_service
HiddenServiceVersion 3
HiddenServicePort 50002 127.0.0.1:50001
Log notice stdout
SocksPort 127.0.0.1:9050
EOF

podman run -d \
  --name "$TOR_NAME" \
  --network host \
  --user 0:0 \
  --security-opt label=disable \
  -v "$TORRC_FILE:/etc/tor/torrc:Z" \
  -v "$TOR_DATA:/data" \
  "$TOR_IMAGE"

############################################
# 3. WAIT ONION (SAFE)
############################################

echo "[3/3] Waiting for onion address..."

ONION=""

for i in {1..60}; do
    ONION=$(podman exec "$TOR_NAME" \
        cat /data/hidden_service/hostname 2>/dev/null || true)

    [[ -n "$ONION" ]] && break
    sleep 2
done

if [[ -z "$ONION" ]]; then
    echo "❌ ERROR: Onion not generated"
    podman logs "$TOR_NAME" --tail 50
    exit 1
fi

mkdir -p "$HOME/.tor-electrum"
echo "$ONION:50002" > "$HOME/.tor-electrum/onion.txt"
chmod 600 "$HOME/.tor-electrum/onion.txt"

# IMPORTANT: no GUI notification (prevents logout issues)

echo ""
echo "================================="
echo " Tor Service started"
echo "================================="
echo
echo "External Wallet Endpoint"
echo
echo "$ONION:50002"
echo
echo "Share this address with compatible Electrum wallets."
echo
echo "To generate a new Onion address:"
echo
echo "1. Stop the Tor service."
echo "2. Delete the hidden service directory:"
echo
echo "   ~/.tor-electrum/data/hidden_service/"
echo
echo "3. Start the Tor service again."
echo
echo "A new Onion address will be created automatically."
echo
