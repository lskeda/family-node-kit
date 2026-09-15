#!/usr/bin/env bash
set -euo pipefail

source "$HOME/family-node-kit/system/lib/tor-runtime.sh"

echo "================================="
echo "          Stop Tor"
echo "================================="

############################################
# 1. STOP TOR
############################################

echo "[1/2] Stopping Tor service..."

TOR_NAME="$(get_tor_container)"

if podman ps --format '{{.Names}}' | grep -qx "$TOR_NAME"; then
    podman stop "$TOR_NAME" >/dev/null
    podman rm "$TOR_NAME" >/dev/null
    echo "✔ Tor service stopped"

elif podman container exists "$TOR_NAME"; then
    podman rm "$TOR_NAME" >/dev/null
    echo "✔ Removed stopped Tor container"

else
    echo "ℹ Tor service is already stopped"
fi

############################################
# 2. PRESERVE IDENTITY
############################################

echo "[2/2] Preserving Onion identity..."

echo "✔ Hidden Service preserved"

echo
echo "================================="
echo "      Tor Service stopped"
echo "================================="
echo
echo "The Onion identity has been preserved."
echo
echo "The next time Tor starts, the same Onion"
echo "address will be reused."
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
