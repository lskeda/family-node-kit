#!/usr/bin/env bash
set -uo pipefail

# Family Node Kit — Bitcoin Core release notification
# Read-only: never downloads or installs software.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIT="$(cd "$SCRIPT_DIR/../.." && pwd)"
RUNTIME="$KIT/system/lib/bitcoin-runtime.sh"
RELEASE_INDEX="https://bitcoincore.org/bin/"

echo "========================================"
echo "   BITCOIN CORE RELEASE CHECK"
echo "========================================"

if [[ ! -f "$RUNTIME" ]]; then
    echo "NOTICE: Bitcoin runtime library not found."
    exit 0
fi

# shellcheck source=/dev/null
source "$RUNTIME"

INSTALLED="$(get_bitcoin_version 2>/dev/null || true)"

if [[ -z "$INSTALLED" ]]; then
    echo "NOTICE: Could not detect the installed Bitcoin Core version."
    exit 0
fi

# Normalize versions such as 31.2.0 to 31.2.
INSTALLED="${INSTALLED#v}"
INSTALLED="${INSTALLED%.*}"
if [[ "$INSTALLED" =~ ^[0-9]+\.[0-9]+$ ]]; then
    :
else
    echo "NOTICE: Unrecognized installed version: $INSTALLED"
    exit 0
fi

INSTALLED_MAJOR="${INSTALLED%%.*}"

echo "Installed version: $INSTALLED"
echo
echo "Checking official Bitcoin Core release directory..."

if ! command -v curl >/dev/null 2>&1; then
    echo "NOTICE: curl is unavailable; release check skipped."
    exit 0
fi

if ! command -v sort >/dev/null 2>&1; then
    echo "NOTICE: sort is unavailable; release check skipped."
    exit 0
fi

HTML="$(curl --fail --silent --show-error --location \
    --connect-timeout 5 --max-time 15 "$RELEASE_INDEX" 2>/dev/null)" || {
    echo "NOTICE: Could not reach the official release directory."
    echo "Bitcoin services are unaffected. Check again later."
    exit 0
}

# Extract stable release directory names only; exclude release candidates.
VERSIONS="$(
    printf '%s\n' "$HTML" |
    grep -oE 'bitcoin-core-[0-9]+\.[0-9]+/' |
    sed -E 's#bitcoin-core-([0-9]+\.[0-9]+)/#\1#' |
    sort -Vu
)"

if [[ -z "$VERSIONS" ]]; then
    echo "NOTICE: No stable release versions could be read."
    echo "No conclusion about updates can be made."
    exit 0
fi

LATEST_BRANCH="$(
    printf '%s\n' "$VERSIONS" |
    awk -F. -v major="$INSTALLED_MAJOR" \
        '$1 == major { print }' |
    sort -V |
    tail -n 1
)"

LATEST_RELEASE="$(
    printf '%s\n' "$VERSIONS" |
    sort -V |
    tail -n 1
)"

echo
if [[ -z "$LATEST_BRANCH" ]]; then
    echo "NOTICE: No release for the installed ${INSTALLED_MAJOR}.x branch was found."
else
    echo "Latest listed ${INSTALLED_MAJOR}.x release: $LATEST_BRANCH"
    if [[ "$LATEST_BRANCH" != "$INSTALLED" ]]; then
        echo "UPDATE NOTICE: A different maintenance version is listed."
        echo "Installed: $INSTALLED"
        echo "Available: $LATEST_BRANCH"
    else
        echo "Installed version matches the latest listed release in this branch."
    fi
fi

echo
echo "Latest stable release listed overall: $LATEST_RELEASE"

if [[ "${LATEST_RELEASE%%.*}" -gt "$INSTALLED_MAJOR" ]]; then
    echo "MAJOR VERSION NOTICE: A newer major release is listed."
    echo "Installed: $INSTALLED"
    echo "Newer branch: $LATEST_RELEASE"
    echo
    echo "A newer major release is informational only."
    echo "Review compatibility and release notes before deciding."
    echo
    echo "To review and update manually:"
    echo "1. Download the official release files to:"
    echo "   ~/Downloads/bitcoin-verify"
    echo
    echo "2. Run the installer:"
    echo "   ~/family-node-kit/tools/install-bitcoin.sh"
    echo
    echo "3. Follow the verification prompts and read:"
    echo "   DOCUMENTATIONS/UPDATE-BITCOIN-CORE.md"
fi

echo
echo "No files changed. No update downloaded or installed."
echo "Review release notes and verify any update manually:"
echo "https://bitcoincore.org/en/releases/"
echo
echo "Don't Trust. Verify."
