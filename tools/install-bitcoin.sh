#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo "   BITCOIN INSTALLER"
echo " Integrity Verification Included"
echo "================================="
echo

############################################
# CONFIG
############################################

INSTALL_DIR="$HOME/bitcoin"
WORK_DIR="$HOME/Downloads/bitcoin-verify"

mkdir -p "$WORK_DIR"

############################################
# 1. LOCATE FILES (SAFE SELECTION)
############################################

echo "[1/5] Searching verification folder..."

# Collect archives safely (no ls parsing)
mapfile -t ARCHIVES < <(
    find "$WORK_DIR" -maxdepth 1 -type f -name "*.tar.gz" | sort
)

if [[ ${#ARCHIVES[@]} -eq 0 ]]; then
    echo "❌ ERROR: No .tar.gz archive found in:"
    echo "   $WORK_DIR"
    exit 1
fi

echo
echo "Available archives:"
echo

for i in "${!ARCHIVES[@]}"; do
    printf "  %d) %s\n" "$((i + 1))" "$(basename "${ARCHIVES[$i]}")"
done

echo
echo "Enter number (1-${#ARCHIVES[@]}):"
read -r CHOICE

# Validate input exists
if [[ -z "$CHOICE" ]]; then
    echo "❌ ERROR: No selection made"
    exit 1
fi

# Validate numeric input
if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
    echo "❌ ERROR: Invalid input (not a number)"
    exit 1
fi

INDEX=$((CHOICE - 1))

# Validate range
if (( INDEX < 0 || INDEX >= ${#ARCHIVES[@]} )); then
    echo "❌ ERROR: Selection out of range"
    exit 1
fi

ARCHIVE="${ARCHIVES[$INDEX]}"

echo "✔ Selected archive: $(basename "$ARCHIVE")"

############################################
# SHA FILE DETECTION (STRICT)
############################################

SHA_FILE=$(find "$WORK_DIR" -maxdepth 1 -type f \
    \( -iname "SHA256SUMS" -o -iname "SHA256SUMS.txt" \
       -o -iname "*shasums*.txt" \) | head -n 1)

if [[ -z "$SHA_FILE" ]]; then
    echo "❌ ERROR: Missing SHA256SUMS file in:"
    echo "   $WORK_DIR"
    exit 1
fi

echo "✔ SHA file: $(basename "$SHA_FILE")"

############################################
# OPTIONAL PGP FILE
############################################

ASC_FILE=$(find "$WORK_DIR" -maxdepth 1 -type f \
    \( -iname "*shasums*.asc" -o -iname "SHA256SUMS.asc" \) | head -n 1 || true)

if [[ -n "$ASC_FILE" ]]; then
    echo "✔ PGP file: $(basename "$ASC_FILE")"
else
    echo "⚠ No PGP file found (SHA256 only verification)"
fi

############################################
# 2. PGP VERIFY
############################################

echo
echo "[2/5] PGP verification..."

if [[ -n "${ASC_FILE:-}" ]]; then

    if command -v gpg >/dev/null 2>&1; then

        GPG_OUTPUT="$(gpg --verify "$ASC_FILE" "$SHA_FILE" 2>&1)" || GPG_STATUS=$?
        GPG_STATUS=${GPG_STATUS:-0}

        echo
        echo "Raw GPG output"
        echo "--------------"
        echo "$GPG_OUTPUT"

        GOOD_SIGS=$(printf '%s\n' "$GPG_OUTPUT" | grep -c "Good signature" || true)
        BAD_SIGS=$(printf '%s\n' "$GPG_OUTPUT" | grep -c "BAD signature" || true)
        MISSING_KEYS=$(printf '%s\n' "$GPG_OUTPUT" | grep -c "No public key" || true)

        echo
        echo "---------------------------------"
        echo
        echo "Summary"
        echo
        printf "Good signatures : %d\n" "$GOOD_SIGS"
        printf "Missing keys    : %d\n" "$MISSING_KEYS"
        printf "Bad signatures  : %d\n" "$BAD_SIGS"

        if (( GOOD_SIGS > 0 )); then

            echo
            echo "Verified release signatures"
            echo

            printf '%s\n' "$GPG_OUTPUT" |
                sed -n 's/.*Good signature from "\(.*\)".*/✓ \1/p'

        fi

        echo
        echo "---------------------------------"
        echo
        echo "Result"
        echo

        if (( BAD_SIGS > 0 )); then

            echo "❌ PGP verification FAILED"
            exit 1

        elif (( GOOD_SIGS > 0 )); then

            echo "✔ Release authenticity verified."

            if (( MISSING_KEYS > 0 )); then
                echo
                echo "Some release signatures could not be"
                echo "verified because their public keys"
                echo "are not installed locally."
            fi

        elif (( MISSING_KEYS > 0 )); then

            echo "⚠ No trusted release signing keys are installed."
            echo
	    echo "This is normal on a new computer."
	    echo
	    echo "PGP verification is optional until trusted"
	    echo "Bitcoin release signing keys are installed."
	    echo
	    echo "SHA256 verification will still confirm that"
	    echo "the downloaded archive matches the official"
	    echo "checksum file."
	    echo
	    echo "To learn how PGP verification works, read:"
	    echo
	    echo "  GPG-VERIFYING-DOWNLOADS.md"

        else

            echo "⚠ Unable to determine signature status."

        fi

        echo
        echo "---------------------------------"
        echo
        echo "Next Step"
        echo
        echo "SHA256 verification..."

    else

        echo "⚠ gpg not installed — skipping PGP verification"

    fi

else

    echo "⚠ No .asc file found — skipping PGP verification"

fi

############################################
# 3. SHA256 VERIFY (MANDATORY)
############################################

echo
echo "[3/5] SHA256 verification..."

FILE_NAME=$(basename "$ARCHIVE")

MATCH=$(grep -F "$FILE_NAME" "$SHA_FILE" || true)

if [[ -z "$MATCH" ]]; then
    echo "❌ ERROR: File not listed in checksum file"
    echo "Expected: $FILE_NAME"
    exit 1
fi

CHECKSUM=$(echo "$MATCH" | awk '{print $1}')

echo "$CHECKSUM  $ARCHIVE" | sha256sum -c -

echo "✔ SHA256 verified"

############################################
# 4. INSTALL
############################################

echo
echo "[4/5] Installing Bitcoin..."

if [[ -d "$INSTALL_DIR" ]]; then
    echo "Existing installation detected:"
    echo "  $INSTALL_DIR"
    echo

    read -rp "Overwrite existing installation? (yes/no): " CONFIRM

    if [[ "$CONFIRM" != "yes" ]]; then
        echo "Installation cancelled."
        exit 0
    fi

    rm -rf "$INSTALL_DIR"
fi

mkdir -p "$INSTALL_DIR"

tar -xzf "$ARCHIVE" -C "$INSTALL_DIR" --strip-components=1

############################################
# 5. FINAL CHECK
############################################

echo
echo "[5/5] Final check..."

if [[ -x "$INSTALL_DIR/bin/bitcoind" && \
      -x "$INSTALL_DIR/bin/bitcoin-cli" ]]; then

    echo "✔ Bitcoin installed successfully"

else
    echo "❌ ERROR: binaries missing after install"
    exit 1
fi

echo
echo "================================="
echo " INSTALL COMPLETE"
echo "================================="
echo
echo "Installed to:"
echo "  $INSTALL_DIR"
echo
echo "NEXT STEP:"
echo
echo " Open Family Node Dashboard"
echo
echo "  • Desktop icon:"
echo "     Family Node Dashboard"
echo
echo "  • Or Application Menu:"
echo "     Family Node Dashboard"
echo
echo "Then select:"
echo
echo "  1) Start Bitcoin + Fulcrum"
echo
echo "IMPORTANT"
echo
echo "• No blockchain data was created."
echo "• No network download was performed."
echo "• SHA256 verification was completed."
echo "• PGP verification was performed when"
echo "  trusted public keys were available."
echo
echo "Want to learn more?"
echo
echo "  GPG-VERIFYING-DOWNLOADS.md"
echo "================================="
