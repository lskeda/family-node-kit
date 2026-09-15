#!/usr/bin/env bash
set -euo pipefail

STATE_DIR="$HOME/.family-node"
STATE_FILE="$STATE_DIR/state.json"

mkdir -p "$STATE_DIR"

get_bitcoin() {
    if pgrep -x bitcoind >/dev/null 2>&1; then
        echo "RUNNING"
    else
        echo "STOPPED"
    fi
}

get_fulcrum() {
    if podman ps --format '{{.Names}}' | grep -q "fulcrum"; then
        echo "RUNNING"
    else
        echo "STOPPED"
    fi
}

get_tor() {
    if podman ps --format '{{.Names}}' | grep -qE '^tor$|^tor-electrum$'; then
        echo "RUNNING"
    else
        echo "STOPPED"
    fi
}

# Build atomic snapshot
TMP_FILE="$(mktemp)"

cat > "$TMP_FILE" <<EOF
{
  "bitcoin": "$(get_bitcoin)",
  "fulcrum": "$(get_fulcrum)",
  "tor": "$(get_tor)",
  "timestamp": "$(date -Iseconds)"
}
EOF

mv "$TMP_FILE" "$STATE_FILE"
