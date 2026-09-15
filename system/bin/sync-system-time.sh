#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo "     SYSTEM TIME SYNCHRONIZATION"
echo "================================="
echo

echo "[1/3] Checking NTP service..."

if ! systemctl is-active --quiet chronyd; then
    echo "❌ NTP service is not running."
    echo
    echo "Start it with:"
    echo "  sudo systemctl enable --now chronyd"
    echo
    exit 1
fi

echo "✔ NTP service active"
echo

echo "[2/3] Synchronizing system time..."

if ! sudo chronyc makestep >/dev/null 2>&1; then
    echo "❌ Unable to synchronize system time."
    echo
    echo "Please check your network connection and try again."
    echo
    exit 1
fi

echo "✔ System time synchronized"
echo

echo "[3/3] Current UTC time:"

date -u '+%H:%M:%S UTC'

echo
echo "================================="

exit 0
