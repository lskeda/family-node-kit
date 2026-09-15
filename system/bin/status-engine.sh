#!/usr/bin/env bash

STATE_ENGINE="$HOME/family-node-kit/system/bin/state-engine.sh"
STATE_FILE="$HOME/.family-node/state.json"

# Ensure state directory exists
mkdir -p "$HOME/.family-node"

# Create snapshot safely
"$STATE_ENGINE" >/dev/null 2>&1 || true

get_state () {
    if [[ ! -f "$STATE_FILE" ]]; then
        echo "UNKNOWN"
        return
    fi

    grep -o "\"$1\": \"[A-Z]*\"" "$STATE_FILE" 2>/dev/null | cut -d'"' -f4

    if [[ -z "$(grep -o "\"$1\": \"[A-Z]*\"" "$STATE_FILE" 2>/dev/null)" ]]; then
        echo "UNKNOWN"
    fi
}

case "${1:-}" in
  bitcoin)
    get_state bitcoin
    ;;
  fulcrum)
    get_state fulcrum
    ;;
  tor)
    get_state tor
    ;;
  all)
    echo "Bitcoin: $(get_state bitcoin)"
    echo "Fulcrum: $(get_state fulcrum)"
    echo "Tor: $(get_state tor)"
    ;;
  *)
    echo "Usage: status-engine.sh {bitcoin|fulcrum|tor|all}"
    ;;
esac
