#!/usr/bin/env bash
set -euo pipefail

echo "===================================="
echo " FAMILY NODE KIT - INSTALL UPDATE"
echo "===================================="
echo

UPDATE_ARCHIVE="${1:-}"

if [[ -z "$UPDATE_ARCHIVE" ]]; then
    echo "Usage:"
    echo "install-update.sh <update-archive.tar.gz>"
    exit 1
fi

if [[ ! -f "$UPDATE_ARCHIVE" ]]; then
    echo "Update archive not found:"
    echo "$UPDATE_ARCHIVE"
    exit 1
fi

echo
echo "[1/5] Stopping services safely..."
family-node stop || true

echo
echo "[2/5] Creating rollback backup..."

BACKUP_DIR="$HOME/family-node-kit/backups"
mkdir -p "$BACKUP_DIR"

tar -czf \
"$BACKUP_DIR/pre-update-$(date +%F-%H%M%S).tar.gz" \
"$HOME/family-node-kit"

echo
echo "[3/5] Extracting update..."

TMP_DIR="$(mktemp -d)"

tar -xzf "$UPDATE_ARCHIVE" -C "$TMP_DIR"

echo
echo "[4/5] Installing updated system..."

rsync -a --delete \
"$TMP_DIR/family-node-kit/" \
"$HOME/family-node-kit/"

echo
echo "[5/5] Restarting services..."

family-node start || true

echo
echo "===================================="
echo " UPDATE COMPLETE"
echo "===================================="
echo
echo "Blockchain data untouched."
echo ".bitcoin preserved."
echo ".fulcrum preserved."
echo
