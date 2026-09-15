#!/usr/bin/env bash
set -euo pipefail

source "$HOME/family-node-kit/system/lib/bitcoin-runtime.sh"
source "$HOME/family-node-kit/system/lib/fulcrum-runtime.sh"

echo
echo "========================================"
echo " CLEAR SYSTEM LOGS"
echo "========================================"
echo

############################################
# SAFETY CHECK
############################################

if is_bitcoin_running; then
    echo "ERROR: Bitcoin is still running."
    echo "Stop services first."
    exit 1
fi

if is_fulcrum_running; then
    echo "ERROR: Fulcrum is still running."
    echo "Stop services first."
    exit 1
fi

echo "System safely stopped."
echo

############################################
# REMOVE LOG FILES
############################################

echo "Removing log files..."

rm -f "$HOME/.bitcoin/debug.log"
rm -f "$HOME/.local/share/bitcoin-service.log"
rm -f "$HOME/.local/share/bitcoin-dashboard.log"

############################################
# FINISHED
############################################

echo
echo "✔ Log cleanup complete."
echo
echo "Nothing else was modified:"
echo "  • Bitcoin blockchain preserved"
echo "  • Fulcrum index preserved"
echo "  • Wallets preserved"
echo "  • Configuration preserved"
echo
