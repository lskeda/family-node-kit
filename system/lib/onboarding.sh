#!/usr/bin/env bash

show_onboarding_help() {
    echo "================================="
    echo " IMPORTANT SAFETY NOTES"
    echo "================================="
    echo "✔ Bootstrap does NOT start Bitcoin or Fulcrum"
    echo "✔ No blockchain data is created or downloaded here"
    echo "✔ .bitcoin and .fulcrum are runtime-only directories"
    echo
    echo "NEXT REQUIRED STEP (FIRST TIME ONLY):"
    echo "  Install Bitcoin:"
    echo "  bash ~/family-node-kit/tools/install-bitcoin.sh"
    echo "  (Only run once per machine)"
    echo
    echo "To start the system:"
    echo "  family-node start"
    echo
    echo "To reset services:"
    echo "  family-node reset"
    echo
    echo "If system time is wrong (IMPORTANT):"
    echo "  sudo timedatectl set-ntp true"
    echo "  sudo systemctl enable --now chronyd"
    echo
    echo "For more information, see:"
    echo "  ~/family-node-kit/DOCUMENTATIONS/"
    echo "================================="
}
