#!/usr/bin/env bash
set -u

source "$HOME/family-node-kit/system/lib/fulcrum-runtime.sh"
source "$HOME/family-node-kit/system/lib/fulcrum-official.sh"

############################################
# LOCAL INFORMATION
############################################

if is_fulcrum_running; then
    LOCAL_STATUS="✓ Running"
else
    LOCAL_STATUS="✗ Not running"
fi

LOCAL_RUNTIME="$(get_fulcrum_runtime)"
LOCAL_SOURCE="$(get_fulcrum_source)"
LOCAL_CONTAINER="$(get_fulcrum_container)"
LOCAL_IMAGE="$(get_fulcrum_image)"
LOCAL_DATA="$(get_fulcrum_data_dir)"

LOCAL_VERSION="$(get_fulcrum_version)"
LOCAL_VERSION="${LOCAL_VERSION:-Unknown}"

LOCAL_RELEASE="$(get_fulcrum_release)"
LOCAL_RELEASE="${LOCAL_RELEASE:-Unknown}"

DIGEST="$(get_fulcrum_image_digest)"
DIGEST="${DIGEST:-Unavailable}"

############################################
# OFFICIAL INFORMATION
############################################

OFFICIAL_VERSION="$(get_official_fulcrum_version)"
OFFICIAL_VERSION="${OFFICIAL_VERSION:-Unknown}"

OFFICIAL_RELEASE="$(get_official_fulcrum_release)"
OFFICIAL_RELEASE="${OFFICIAL_RELEASE:-Unknown}"

PROJECT_URL="$(get_fulcrum_project_url)"

############################################
# VERIFICATION STATUS
############################################

STATUS="🟡 PARTIALLY VERIFIED"
MESSAGE="Official verification could not be completed."

#
# Installed version cannot be determined.
#
if [[ "$LOCAL_VERSION" == "Unknown" ]] ||
   [[ "$LOCAL_RELEASE" == "Unknown" ]]; then

    STATUS="🟡 PARTIALLY VERIFIED"
    MESSAGE="The installed Fulcrum version could not be determined.

Start Fulcrum to complete version verification."

#
# Official version cannot be determined.
#
elif [[ "$OFFICIAL_VERSION" == "Unknown" ]] ||
     [[ "$OFFICIAL_RELEASE" == "Unknown" ]]; then

    STATUS="🟡 PARTIALLY VERIFIED"
    MESSAGE="Official verification could not be completed."

#
# Installed version and release match the official reference.
#
elif [[ "$LOCAL_VERSION" == "$OFFICIAL_VERSION" ]] &&
     [[ "$LOCAL_RELEASE" == "$OFFICIAL_RELEASE" ]]; then

    STATUS="🟢 VERIFIED"
    MESSAGE="The installed Fulcrum matches the official release."

#
# Installed version is older than the official release.
#
elif [[ "$(printf '%s\n' "$LOCAL_VERSION" "$OFFICIAL_VERSION" | sort -V | head -n1)" == "$LOCAL_VERSION" ]]; then

    STATUS="🟡 UPDATE AVAILABLE"
    MESSAGE="A newer official Fulcrum release is available.

Installed:
  $LOCAL_VERSION / $LOCAL_RELEASE

Official:
  $OFFICIAL_VERSION / $OFFICIAL_RELEASE

Verify the official release before deciding whether to update."

#
# Installed version is newer than the official reference.
#
else

    STATUS="🟡 NEWER VERSION DETECTED"
    MESSAGE="The installed Fulcrum is newer than the official release currently recognized by Family Node Kit.

Installed:
  $LOCAL_VERSION / $LOCAL_RELEASE

Official:
  $OFFICIAL_VERSION / $OFFICIAL_RELEASE

No downgrade will be performed.

Verify the installed release independently."

fi

############################################
# REPORT
############################################

echo
echo "================================="
echo "     FULCRUM VERIFICATION"
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
echo "Version:"
echo "  $LOCAL_VERSION"
echo
echo "Release:"
echo "  $LOCAL_RELEASE"
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
echo "Release:"
echo "  $OFFICIAL_RELEASE"
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
echo "  ✓ Official release comparison"
echo "  ✓ OCI image identification"
echo
echo "----------------------------------"

exit 0
