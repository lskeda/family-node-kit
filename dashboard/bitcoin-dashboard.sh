#!/usr/bin/env bash
set -euo pipefail

printf '\033]0;Family Node Kit Dashboard\007'

LOG="$HOME/.local/share/bitcoin-dashboard.log"
mkdir -p "$(dirname "$LOG")"

############################################
# SAFE SUDO KEEPALIVE (non-fatal)
############################################

sudo -v || true

(
while true; do
    sudo -n true 2>/dev/null || true
    sleep 60
done
) &
SUDO_KEEPALIVE_PID=$!

trap "kill $SUDO_KEEPALIVE_PID 2>/dev/null || true" EXIT

############################################
# STATUS ENGINE
############################################

STATUS_ENGINE="$HOME/family-node-kit/system/bin/status-engine.sh"

############################################
# HEALTH ENGINE
############################################

source "$HOME/family-node-kit/system/lib/bitcoin-runtime.sh"

source "$HOME/family-node-kit/system/lib/fulcrum-runtime.sh"
source "$HOME/family-node-kit/system/lib/fulcrum-official.sh"

source "$HOME/family-node-kit/system/lib/tor-runtime.sh"
source "$HOME/family-node-kit/system/lib/tor-official.sh"

source "$HOME/family-node-kit/system/lib/health-runtime.sh"

############################################
# SAFE STATUS CALL
############################################

get_status () {
    local svc="$1"

    if [[ -x "$STATUS_ENGINE" ]]; then
        "$STATUS_ENGINE" "$svc" 2>/dev/null || echo "unknown"
    else
        echo "no-engine"
    fi
}

############################################
# MAIN LOOP
############################################

while true; do
    clear

    echo "================================="
    echo "      FAMILY NODE DASHBOARD"
    echo "================================="
    echo

    ############################################
    # SYSTEM STATUS
    ############################################

    echo "CURRENT STATUS"
    echo
    echo "TIME: $(date -u '+%H:%M UTC')"
    echo

    BTC_STATUS=$(get_status bitcoin)
    FULCRUM_STATUS=$(get_status fulcrum)
    TOR_STATUS=$(get_status tor)

    BTC_HEALTH=$(get_bitcoin_health_status)
    FULCRUM_HEALTH=$(get_fulcrum_health_status)
    TOR_HEALTH=$(get_tor_health_status)

    printf "%-10s %-9s %s\n" "Bitcoin :" "$BTC_STATUS" "$BTC_HEALTH"
    printf "%-10s %-9s %s\n" "Fulcrum :" "$FULCRUM_STATUS" "$FULCRUM_HEALTH"
    printf "%-10s %-9s %s\n" "Tor :" "$TOR_STATUS" "$TOR_HEALTH"

    echo
    echo "---------------------------------"
    echo

    ############################################
    # MENU
    ############################################

    echo "UTC) Synchronize System Time"
    echo
    echo "KIT) Family Node Kit Health Report"
    echo
    echo "---------------------------------"
    echo
    echo "1) Start Bitcoin + Fulcrum"
    echo "2) Open Sparrow Wallet"
    echo
    echo "3) Start Tor Proxy + External Wallet"
    echo "4) Stop Tor Proxy"
    echo
    echo "5) Show Onion Address (connect External Wallet)"
    echo
    echo "RPC) Rotate Bitcoin RPC Password"
    echo "COINJ) Open Wasabi Wallet"
    echo
    echo "RESET) Reset Node"
    echo "CLEAN) Clear System Log Only"
    echo
    echo "STOP) Stop Bitcoin Services"
    echo
    echo "0) Exit"
    echo

    read -rp "Select option: " CHOICE
    echo

    case "$CHOICE" in

        UTC)
            echo "[ACTION] Synchronizing system time..."
            "$HOME/family-node-kit/system/bin/sync-system-time.sh" || true
            read -rp "Press Enter..."
            ;;

        KIT)
            family-node verify || true
            read -rp "Press Enter..."
            ;;

        1)
            echo "[ACTION] Starting Bitcoin + Fulcrum..."
            echo "$(date) START" >> "$LOG"
            family-node start || true
            read -rp "Press Enter..."
            ;;

        2)
            echo "[ACTION] Opening Sparrow..."
            nohup "$HOME/Sparrow/bin/Sparrow" >/dev/null 2>&1 &
            disown
            ;;

        3)
            echo "[ACTION] Starting Tor Proxy + External Wallet..."
            family-node tor-start || true
            read -rp "Press Enter..."
            ;;

        4)
            echo "[ACTION] Stopping Tor..."
            family-node tor-stop || true
            read -rp "Press Enter..."
            ;;

        5)
            ONION_FILE="$HOME/.tor-electrum/onion.txt"

            echo "[INFO] Onion address:"
            echo

            [[ -f "$ONION_FILE" ]] && cat "$ONION_FILE" || echo "Not available yet"

            read -rp "Press Enter..."
            ;;

        RPC)
            echo "[ACTION] Rotating RPC..."
            family-node rotate || true
            read -rp "Press Enter..."
            ;;

        COINJ)
            WASABI="$HOME/Apps/Wasabi/Wasabi-2.8.3.AppImage"

            if [[ ! -x "$WASABI" ]]; then
                echo "[ERROR] Wasabi Wallet not found:"
                echo "        $WASABI"
                read -rp "Press Enter..."
            elif ! is_bitcoin_running; then
                echo "[ERROR] Bitcoin Core is not running."
                echo "Please start Bitcoin + Fulcrum first."
                read -rp "Press Enter..."
            else
                echo "[ACTION] Opening Wasabi Wallet..."
                nohup "$WASABI" >/dev/null 2>&1 &
                disown
            fi
            ;;

        RESET)
            echo "[ACTION] Reset node..."
            family-node reset || true
            read -rp "Press Enter..."
            ;;

        CLEAN)
            echo "[ACTION] Cleaning..."
            family-node clean || true
            read -rp "Press Enter..."
            ;;

        STOP)
            echo "[ACTION] Stopping Bitcoin Services..."
            family-node stop || true
            read -rp "Press Enter..."
            ;;

        0)
            echo "Exiting..."
            exit 0
            ;;

        *)
            echo "Invalid option"
            sleep 1
            ;;
    esac

done
