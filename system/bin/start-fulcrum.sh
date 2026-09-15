#!/usr/bin/env bash
set -euo pipefail

source "$HOME/family-node-kit/system/lib/fulcrum-runtime.sh"
source "$HOME/family-node-kit/system/lib/fulcrum-official.sh"

echo "================================="
echo "        FULCRUM START"
echo "================================="

############################################
# LOAD RPC CONFIG
############################################

CONFIG="$HOME/.family-node-kit/env/rpc.env"

if [[ ! -f "$CONFIG" ]]; then
    echo "❌ Missing RPC config: $CONFIG"
    exit 1
fi

source "$CONFIG"

if [[ -z "${RPC_USER:-}" || -z "${RPC_PASS:-}" ]]; then
    echo "❌ RPC credentials missing or empty"
    exit 1
fi

############################################
# CONFIG
############################################

FULCRUM_IMAGE="$(get_official_fulcrum_image)"
FULCRUM_NAME="$(get_fulcrum_container)"
FULCRUM_DATA="$HOME/.fulcrum"

############################################
# UPDATE DETECTION STATE
############################################

UPDATE_STATE_DIR="$HOME/.family-node-kit/state"
UPDATE_STATE_FILE="$UPDATE_STATE_DIR/fulcrum-update-available"

mkdir -p "$UPDATE_STATE_DIR"

############################################
# CHECK FULCRUM VERSION
############################################

INSTALLED_VERSION="$(get_fulcrum_version 2>/dev/null || true)"
INSTALLED_VERSION="${INSTALLED_VERSION:-Unknown}"

OFFICIAL_VERSION="$(get_official_fulcrum_version 2>/dev/null || true)"
OFFICIAL_VERSION="${OFFICIAL_VERSION:-Unknown}"

OFFICIAL_RELEASE="$(get_official_fulcrum_release 2>/dev/null || true)"
OFFICIAL_RELEASE="${OFFICIAL_RELEASE:-Unknown}"

echo
echo "Installed Fulcrum : $INSTALLED_VERSION"
echo "Official Fulcrum  : $OFFICIAL_VERSION"
echo

############################################
# UPDATE IMAGE PREPARATION
############################################

prepare_fulcrum_update() {

    local target_image
    local target_version
    local target_release
    local official_digest
    local image_digest

    target_version="$(get_official_fulcrum_version 2>/dev/null || true)"
    target_release="$(get_official_fulcrum_release 2>/dev/null || true)"
    target_image="$(get_official_fulcrum_image 2>/dev/null || true)"
    official_digest="$(get_official_fulcrum_amd64_digest 2>/dev/null || true)"

    if [[ -z "$target_version" ||
          -z "$target_release" ||
          -z "$target_image" ||
          -z "$official_digest" ]]; then

        echo "❌ Unable to determine the official Fulcrum release."
        return 1
    fi

    echo
    echo "Official Fulcrum update target:"
    echo "  Version : $target_version"
    echo "  Release : $target_release"
    echo "  Image   : $target_image"
    echo "  Digest  : $official_digest"
    echo

    echo "[1/3] Pulling official Fulcrum image..."

    if ! podman pull "$target_image"; then
        echo
        echo "❌ Failed to pull the official Fulcrum image."
        echo "ℹ Existing Fulcrum installation has NOT been removed."
        return 1
    fi

    echo
    echo "✔ Official image pulled."
    echo
    echo "[2/3] Inspecting pulled image..."

    image_digest="$(
        podman image inspect "$target_image" \
            --format '{{.Digest}}' 2>/dev/null
    )"

    if [[ -z "$image_digest" ]]; then
        echo "❌ Unable to determine the pulled image digest."
        echo "ℹ Existing Fulcrum installation has NOT been removed."
        return 1
    fi

    echo "  Pulled digest:"
    echo "  $image_digest"
    echo
    echo "  Official digest:"
    echo "  $official_digest"
    echo

    echo "[3/3] Verifying image identity..."

    if [[ "$image_digest" != "$official_digest" ]]; then
        echo
        echo "❌ IMAGE VERIFICATION FAILED"
        echo
        echo "The pulled image does not match the official"
        echo "AMD64 image digest."
        echo
        echo "ℹ Existing Fulcrum installation has NOT been removed."
        return 1
    fi

    echo "✔ Image digest matches the official AMD64 image."
    echo
    echo "✔ Official image preparation completed."
    echo "ℹ Existing Fulcrum container has NOT been removed."

    return 0
}

############################################
# REPLACE FULCRUM CONTAINER
############################################

replace_fulcrum_container() {

    local target_image
    local update_container="fulcrum-update"
    local banner
    local verified_version
    local verified_release

    target_image="$(get_official_fulcrum_image 2>/dev/null || true)"

    if [[ -z "$target_image" ]]; then
        echo "❌ Unable to determine the official Fulcrum image."
        return 1
    fi

    echo
    echo "Preparing staged Fulcrum replacement..."
    echo "  Image: $target_image"
    echo

    ############################################
    # CLEAN OLD TEST CONTAINER
    ############################################

    podman rm -f "$update_container" 2>/dev/null || true

    ############################################
    # CREATE STAGED CONTAINER
    ############################################

    echo "[1/4] Creating temporary Fulcrum container..."

    if ! podman run -d \
        --name "$update_container" \
        --network host \
        -v "$FULCRUM_DATA:/data:Z" \
        "$target_image" \
        Fulcrum \
            -b 127.0.0.1:8332 \
            --rpcuser="$RPC_USER" \
            --rpcpassword="$RPC_PASS" \
            --tcp 127.0.0.1:50001
    then
        echo
        echo "❌ Failed to create the temporary Fulcrum container."
        echo "ℹ Existing Fulcrum container has NOT been removed."
        return 1
    fi

    echo "✔ Temporary container created."

    ############################################
    # VERIFY STAGED IMAGE
    ############################################

    echo
    echo "[2/4] Verifying staged container image..."

    local container_image

    container_image="$(
        podman inspect "$update_container" \
            --format '{{.Config.Image}}' 2>/dev/null
    )"

    if [[ "$container_image" != "$target_image" ]]; then
        echo
        echo "❌ Staged container image verification failed."
        echo "Expected:"
        echo "  $target_image"
        echo "Found:"
        echo "  $container_image"
        echo
        echo "ℹ Existing Fulcrum container has NOT been removed."

        podman rm -f "$update_container" 2>/dev/null || true
        return 1
    fi

    echo "✔ Staged container uses the official image."

    ############################################
    # VERIFY FULCRUM VERSION
    ############################################

    echo
    echo "[3/4] Verifying Fulcrum version..."

        banner=""

        for i in {1..30}; do

            banner="$(
                podman logs "$update_container" 2>/dev/null |
                awk '/Fulcrum / { print; exit }'
            )"

            if [[ -n "$banner" ]]; then
                break
            fi

            sleep 1
        done

        if [[ -z "$banner" ]]; then
            echo
            echo "❌ Fulcrum startup banner was not detected."
            echo
            echo "ℹ Existing Fulcrum container has NOT been removed."

            podman logs "$update_container" 2>/dev/null | tail -20
            podman rm -f "$update_container" 2>/dev/null || true
            return 1
        fi

    verified_version="$(
        printf '%s\n' "$banner" |
        sed -E 's/.*Fulcrum ([0-9.]+).*/\1/'
    )"

    verified_release="$(
        printf '%s\n' "$banner" |
        sed -E 's/.*Release ([^)]+).*/\1/'
    )"

    if [[ "$verified_version" != "$OFFICIAL_VERSION" ]] ||
       [[ "$verified_release" != "$OFFICIAL_RELEASE" ]]; then

        echo
        echo "❌ Fulcrum version verification failed."
        echo
        echo "Expected:"
        echo "  $OFFICIAL_VERSION / $OFFICIAL_RELEASE"
        echo
        echo "Detected:"
        echo "  ${verified_version:-Unknown} / ${verified_release:-Unknown}"
        echo
        echo "ℹ Existing Fulcrum container has NOT been removed."

        podman logs "$update_container" 2>/dev/null | tail -20
        podman rm -f "$update_container" 2>/dev/null || true
        return 1
    fi

    echo "✔ Fulcrum version verified:"
    echo "  $verified_version / $verified_release"

    ############################################
    # FINAL CONTAINER REPLACEMENT
    ############################################

    echo
    echo "[4/4] Replacing existing Fulcrum container..."

    if ! podman rm -f "$FULCRUM_NAME" 2>/dev/null; then
        echo "❌ Failed to remove the existing Fulcrum container."
        echo "ℹ Temporary verified container remains:"
        echo "  $update_container"
        return 1
    fi

    if ! podman rename "$update_container" "$FULCRUM_NAME"; then
        echo
        echo "❌ Failed to rename the verified container."
        echo "ℹ The verified container remains:"
        echo "  $update_container"
        return 1
    fi

    echo "✔ Fulcrum container replacement completed."

    return 0
}


############################################
# DECIDE
############################################

FULCRUM_ACTION="START"
FULCRUM_ALREADY_STARTED="false"

if [[ "$INSTALLED_VERSION" == "Unknown" ]]; then

    echo "ℹ Fulcrum installation not detected."
    echo "ℹ The official Fulcrum release will be installed."

    FULCRUM_ACTION="INSTALL"

elif [[ "$INSTALLED_VERSION" == "$OFFICIAL_VERSION" ]]; then

    echo "✔ Fulcrum is already at the official release."

    # Official version is installed.
    # Remove any previous update notification.
    rm -f "$UPDATE_STATE_FILE"

    FULCRUM_ACTION="START"

elif [[ "$(printf '%s\n' "$INSTALLED_VERSION" "$OFFICIAL_VERSION" | sort -V | head -n1)" == "$INSTALLED_VERSION" ]]; then

    echo "🟡 A newer official Fulcrum release is available."
    echo
    echo "Installed : $INSTALLED_VERSION"
    echo "Available : $OFFICIAL_VERSION"
    echo

    #
    # First detection:
    # Inform the user, but do not ask for an update.
    #
    if [[ ! -f "$UPDATE_STATE_FILE" ]]; then

        echo "ℹ This is the first detection of this update."
        echo "ℹ Fulcrum will start normally."
        echo "ℹ Review the official release before updating."

        printf '%s\n' "$OFFICIAL_VERSION" > "$UPDATE_STATE_FILE"

        FULCRUM_ACTION="START"

    #
    # Update was already detected previously:
    # Ask the user before updating.
    #
    else

        PREVIOUS_UPDATE="$(cat "$UPDATE_STATE_FILE" 2>/dev/null || true)"

        if [[ "$PREVIOUS_UPDATE" != "$OFFICIAL_VERSION" ]]; then

            echo "ℹ A newer official version is now available."
            echo "ℹ The previous update notice was for:"
            echo "  $PREVIOUS_UPDATE"
            echo

            printf '%s\n' "$OFFICIAL_VERSION" > "$UPDATE_STATE_FILE"

            echo "ℹ This new version will be reported first."
            echo "ℹ Fulcrum will start normally."

            FULCRUM_ACTION="START"

        else

            read -rp "Update Fulcrum now? [Y/N]: " ANSWER

            case "$ANSWER" in
                Y|y)
    		    echo
    		    echo "✔ Update selected."

    		    if prepare_fulcrum_update; then
    			if replace_fulcrum_container; then
        		    FULCRUM_ACTION="UPDATE"
			    FULCRUM_ALREADY_STARTED="true"
    		        else
        		    echo
        		    echo "❌ Fulcrum container replacement failed."
        		    echo "ℹ Fulcrum data has NOT been deleted."
        		    FULCRUM_ACTION="START"
    		        fi
    		    else
        		echo
        		echo "❌ Update preparation failed."
        		echo "ℹ Keeping the existing Fulcrum installation."
        		FULCRUM_ACTION="START"
    		    fi
                    ;;
                *)
                    echo
                    echo "ℹ Update declined."
                    echo "ℹ Keeping installed Fulcrum $INSTALLED_VERSION."
                    FULCRUM_ACTION="START"
                    ;;
            esac

        fi

    fi

else

    echo "🟡 Installed Fulcrum is newer than the official release."
    echo
    echo "Installed : $INSTALLED_VERSION"
    echo "Official  : $OFFICIAL_VERSION"
    echo
    echo "ℹ No downgrade will be performed."

    FULCRUM_ACTION="START"

fi

############################################
# DATA DIRECTORY
############################################

if [[ ! -d "$FULCRUM_DATA" ]]; then
    echo "[INFO] Creating Fulcrum data directory..."
    mkdir -p "$FULCRUM_DATA"
fi

############################################
# START
############################################

if [[ "$FULCRUM_ALREADY_STARTED" == "true" ]]; then

    echo "[1/2] Fulcrum already running after update."
    echo "✔ Skipping container creation."

elif is_fulcrum_running; then

    echo "[1/2] Fulcrum is already running."
    echo "✔ Skipping container creation."

elif podman container exists "$FULCRUM_NAME" 2>/dev/null; then

    echo "[1/2] Starting existing Fulcrum container..."
    
    if ! podman start "$FULCRUM_NAME" >/dev/null; then
        echo "❌ Failed to start existing Fulcrum container."
        exit 1
    fi

    echo "✔ Existing Fulcrum container started."

else

    echo "[1/2] Starting Fulcrum..."

    podman run -d \
      --name "$FULCRUM_NAME" \
      --network host \
      -v "$FULCRUM_DATA:/data:Z" \
      "$FULCRUM_IMAGE" \
      Fulcrum \
        -b 127.0.0.1:8332 \
        --rpcuser="$RPC_USER" \
        --rpcpassword="$RPC_PASS" \
        --tcp 127.0.0.1:50001

fi

############################################
# WAIT FOR READINESS (PORT CHECK)
############################################

echo "[2/2] Waiting for Fulcrum to become reachable..."
echo "ℹ Port 50001 opens only AFTER indexing is complete"
echo "ℹ Indexing can take hours/days on first run"
echo

for i in {1..2}; do
    if timeout 1 bash -c "echo > /dev/tcp/127.0.0.1/50001" 2>/dev/null; then
        echo "✔ Fulcrum READY (port 50001 open)"
        exit 0
    fi

    echo "⏳ Not ready yet... ($i/2)"
    sleep 5
done

echo
echo "⚠ Fulcrum is still indexing (this is NORMAL on first run)"
echo

echo "👉 Live Bitcoin sync progress:"
echo "   tail -f ~/.bitcoin/debug.log"
echo "   (Press Ctrl+C to stop viewing)"
echo

echo "👉 Live Fulcrum indexing:"
echo "   podman logs -f fulcrum"
echo "   (Press Ctrl+C to stop viewing)"
echo

echo "👉 Status check:"
echo "   podman ps | grep fulcrum"
echo

echo "To stop safely:"
echo "  RESET) Reset Node"
echo

echo "✔ You can safely leave this running in background"
echo "✔ Fulcrum process launched (running in background)"
exit 0
