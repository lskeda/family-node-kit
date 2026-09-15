#!/usr/bin/env bash
set -u

source "$HOME/family-node-kit/system/lib/tor-runtime.sh"
source "$HOME/family-node-kit/system/lib/tor-official.sh"

############################################
# LOCAL INFORMATION
############################################

if is_tor_running; then
    LOCAL_STATUS="✓ Running"
else
    LOCAL_STATUS="✗ Not running"
fi

LOCAL_RUNTIME="$(get_tor_runtime)"
LOCAL_SOURCE="$(get_tor_source)"
LOCAL_CONTAINER="$(get_tor_container)"
LOCAL_IMAGE="$(get_tor_image)"
LOCAL_DATA="$(get_tor_data_dir)"

ONION="$(get_tor_onion_address)"
ONION="${ONION:-Unavailable}"

SOCKS_PROXY="$(get_tor_socks_proxy)"

HIDDEN_SERVICE_PORT="$(get_tor_hidden_service_port)"

DIGEST="$(get_tor_image_digest)"
DIGEST="${DIGEST:-Unavailable}"

############################################
# OFFICIAL INFORMATION
############################################

OFFICIAL_VERSION="$(get_official_tor_version)"
OFFICIAL_VERSION="${OFFICIAL_VERSION:-Unknown}"

PROJECT_URL="$(get_tor_project_url)"

############################################
# VERIFICATION STATUS
############################################

STATUS="🟡 PARTIALLY VERIFIED"
MESSAGE="Official verification could not be completed."

# Future enhancement:
# When a reliable official Tor version becomes available,
# compare it here and promote the status to VERIFIED or
# VERIFICATION FAILED.

############################################
# REPORT
############################################

echo "================================="
echo "       TOR VERIFICATION"
echo "================================="
echo

echo "Component"
echo
echo "Status:"
echo "  $LOCAL_STATUS"
echo
echo "Runtime:"
echo "  $LOCAL_RUNTIME"
echo
echo "Source:"
echo "  $LOCAL_SOURCE"
echo
echo "Container:"
echo "  $LOCAL_CONTAINER"
echo
echo "Image:"
echo "  $LOCAL_IMAGE"
echo
echo "Data Directory:"
echo "  $LOCAL_DATA"
echo

echo "---------------------------------"
echo

echo "Installed"
echo
echo "Onion Address:"
echo "  $ONION"
echo

echo "Hidden Service Port:"
echo "  $HIDDEN_SERVICE_PORT"
echo

echo "SOCKS Proxy:"
echo "  $SOCKS_PROXY"
echo

echo "Digest:"
echo "  $DIGEST"
echo

echo "---------------------------------"
echo

echo "Official"
echo
echo "Version:"
echo "  $OFFICIAL_VERSION"
echo
echo "Project:"
echo "  $PROJECT_URL"
echo

echo "----------------------------------"
echo

echo "Verification Status"
echo
echo "$STATUS"
echo
echo "$MESSAGE"
echo

echo "----------------------------------"
echo

echo "Verification includes:"
echo
echo "  ✓ Runtime inspection"
echo "  ✓ Hidden Service configuration"
echo "  ✓ SOCKS proxy configuration"
echo "  ✓ Container image identification"
echo "  ✓ Official project reference"
echo

echo "----------------------------------"

exit 0
