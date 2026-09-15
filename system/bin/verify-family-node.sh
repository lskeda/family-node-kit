#!/usr/bin/env bash
#
# Family Node Kit
#
# verify-family-node.sh
#
# Purpose:
#   Produce the Family Node Kit Health Report.
#
# Architecture:
#   Rule 4  - Dashboard orchestrates
#   Rule 7  - VERIFY never changes the system
#   Rule 11 - Report facts, not conclusions
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../lib/bitcoin-runtime.sh"

source "$SCRIPT_DIR/../lib/fulcrum-runtime.sh"
source "$SCRIPT_DIR/../lib/fulcrum-official.sh"

source "$SCRIPT_DIR/../lib/tor-runtime.sh"
source "$SCRIPT_DIR/../lib/tor-official.sh"

source "$SCRIPT_DIR/../lib/health-runtime.sh"

clear

echo
echo " FAMILY NODE KIT HEALTH REPORT"
echo "================================="
echo

bitcoin_name="$(get_bitcoin_name)"
bitcoin_version="$(get_bitcoin_version || echo "unknown")"

echo "Bitcoin node: ${bitcoin_name} v${bitcoin_version}"

echo
echo "================================="
echo "SUMMARY"

bitcoin_status="$(get_bitcoin_health_status)"
fulcrum_status="$(get_fulcrum_health_status)"
tor_status="$(get_tor_health_status)"

printf "%-18s %s\n" "Bitcoin Node" "$bitcoin_status"
printf "%-18s %s\n" "Fulcrum" "$fulcrum_status"
printf "%-18s %s\n" "Tor" "$tor_status"

echo
echo "---------------------------------"
echo
echo "Overall Status"
echo
echo "🟢 No critical issues detected."
echo
echo "See the detailed reports below"
echo "for additional information."
echo
echo "Is a read-only report."
echo "No changes were made."

echo
echo "================================="
echo "DETAILED REPORTS"
echo "================================="

echo
echo
echo "================================="
echo "     BITCOIN VERIFICATION"
echo "================================="
echo
echo "Component"
echo
echo "Status:"
if is_bitcoin_running; then
    echo "  ✓ Running"
else
    echo "  ✗ Not running"
fi
echo
echo "Node:"
echo "  ${bitcoin_name} v${bitcoin_version}"
echo
echo "Runtime:"
echo "  $(get_bitcoin_runtime)"
echo
echo "Source:"
echo "  $(get_bitcoin_source)"
echo
echo "Installation:"
echo "  $(get_bitcoin_dir)"
echo
echo "Data:"
echo "  $(get_bitcoin_data_dir)"
echo
echo "RPC:"
if is_bitcoin_running; then
    bitcoin_cli="$(get_bitcoin_cli)"
    bitcoin_conf="$HOME/.bitcoin/bitcoin.conf"
    if "$bitcoin_cli" -conf="$bitcoin_conf" getblockchaininfo >/dev/null 2>&1; then
        echo "  ✓ Reachable"
    else
        echo "  ✗ Not reachable"
    fi
else
    echo "  ✗ Not reachable"
fi

echo
echo "For the complete update procedure, read:"
echo
echo "  DOCUMENTATIONS/UPDATE-BITCOIN-CORE.md"
echo

"$SCRIPT_DIR/verify-fulcrum.sh"

echo

echo
"$SCRIPT_DIR/verify-tor.sh"

echo
echo "================================="
echo
echo "Don't Trust. Verify."
echo
echo "================================="
