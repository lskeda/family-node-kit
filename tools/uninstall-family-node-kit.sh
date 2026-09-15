#!/usr/bin/env bash
set -euo pipefail

BASE="$HOME/family-node-kit/system/bin"

echo "================================="
echo " FAMILY NODE KIT UNINSTALL"
echo "================================="
echo

echo "This utility will remove:"
echo
echo "  ✔ Family Node Kit"
echo "  ✔ Bitcoin program"
echo "  ✔ Fulcrum container"
echo "  ✔ Tor container"
echo "  ✔ Fulcrum image"
echo "  ✔ Tor image"
echo "  ✔ Tor configuration"
echo "  ✔ Desktop launcher"
echo
echo "The following will NOT be removed:"
echo
echo "  ✔ ~/.bitcoin"
echo "  ✔ ~/.fulcrum"
echo "  ✔ Wallets"
echo "  ✔ Blockchain"
echo "  ✔ Fulcrum index"
echo

read -rp "Type UNINSTALL to continue: " ANSWER

if [[ "$ANSWER" != "UNINSTALL" ]]; then
    echo
    echo "Aborted."
    exit 0
fi

############################################
# 1. STOP SERVICES
############################################

echo
echo "[1/6] Stopping Bitcoin services..."

if [[ -x "$BASE/stop-bitcoin-services.sh" ]]; then
    "$BASE/stop-bitcoin-services.sh"
fi

############################################
# 2. REMOVE CONTAINERS
############################################

echo
echo "[2/6] Removing containers..."

for c in fulcrum tor tor-electrum; do
    podman rm -f "$c" 2>/dev/null || true
done

############################################
# 3. REMOVE IMAGES
############################################

echo
echo "[3/6] Removing container images..."

############################################
# REMOVE FULCRUM IMAGE
############################################

source "$HOME/family-node-kit/system/lib/fulcrum-runtime.sh"

FULCRUM_IMAGE="$(get_fulcrum_image)"

if [[ -n "$FULCRUM_IMAGE" ]]; then
    podman rmi "$FULCRUM_IMAGE" 2>/dev/null || true
    echo "✔ Fulcrum image removed: $FULCRUM_IMAGE"
else
    echo "ℹ No versioned Fulcrum image found"
fi

podman rmi docker.io/osminogin/tor-simple:latest \
    2>/dev/null || true

############################################
# 4. REMOVE BITCOIN
############################################

echo
echo "[4/6] Removing Bitcoin..."

rm -rf "$HOME/bitcoin"

############################################
# 5. REMOVE FAMILY NODE KIT
############################################

echo
echo "[5/6] Removing Family Node Kit..."

rm -rf "$HOME/family-node-kit"
rm -rf "$HOME/.family-node-kit"
rm -rf "$HOME/.family-node"

############################################
# REMOVE TOR DATA
############################################

rm -rf "$HOME/.tor-electrum"

############################################
# 6. REMOVE DESKTOP LAUNCHER
############################################

echo
echo "[6/6] Removing desktop launcher..."

rm -f "$HOME/.local/share/applications/family-node-dashboard.desktop"

rm -f "$HOME/.local/share/icons/hicolor/48x48/apps/dashboard.png"

update-desktop-database \
    "$HOME/.local/share/applications" \
    >/dev/null 2>&1 || true

############################################
# COMPLETE
############################################

echo
echo "================================="
echo " UNINSTALL COMPLETE"
echo "================================="
echo

echo "Removed:"
echo "  ✔ Family Node Kit"
echo "  ✔ Bitcoin program"
echo "  ✔ Fulcrum container"
echo "  ✔ Tor container"
echo "  ✔ Fulcrum image"
echo "  ✔ Tor image"
echo "  ✔ Tor configuration"
echo "  ✔ Desktop launcher"
echo

echo "Preserved:"
echo "  ✔ ~/.bitcoin"
echo "  ✔ ~/.fulcrum"
echo "  ✔ Wallets"
echo "  ✔ Blockchain"
echo "  ✔ Fulcrum index"
echo

echo "Nothing important was deleted."
echo
echo "================================="
echo " Don't Trust. Verify."
echo "================================="
