#!/usr/bin/env bash
set -euo pipefail

############################################
# BASE PATH (MUST BE FIRST)
############################################

KIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SYSTEM_DIR="$KIT_DIR/system/bin"

############################################
# ENTRY POINT (README-FIRST)
############################################

if [[ -f "$KIT_DIR/README-FIRST.txt" ]]; then
    echo "================================="
    cat "$KIT_DIR/README-FIRST.txt"
    echo "================================="
    read -n 1 -s -r -p "Press any key to continue..."
    echo
fi

############################################
# 0. WELCOME
############################################

clear

echo "================================="
echo "   FAMILY NODE INSTALLATION"
echo "================================="
echo
echo "This installer will set up:"
echo "  ✔ Family Node Kit"
echo "  ✔ Dashboard launcher"
echo "  ✔ Desktop icon"
echo "  ✔ Fulcrum Indexer"
echo "  ✔ Tor Service (installed automatically when first started)"
echo "  ✔ Bitcoin MUST be installed separately (README-FIRST.txt)"
echo "  ✔ Sparrow Wallet MUST be installed separately (README-FIRST.txt)"
echo

read -rp "Press ENTER to continue..."

############################################
# 1. SYSTEM CHECK
############################################

clear
echo "[STEP 1] Checking system..."

if ! command -v podman >/dev/null 2>&1; then
    echo "❌ Podman not installed"
    exit 1
fi

echo "✔ System OK"

read -rp "Press ENTER..."

############################################
# 2. CONFIRMATION
############################################

clear

echo "[STEP 2] Storage requirement"
echo "Minimum 2TB SSD required"
echo

read -rp "Type YES to continue: " CONFIRM

[[ "$CONFIRM" != "YES" ]] && exit 0

############################################
# 3. INSTALL FAMILY NODE KIT
############################################

echo
echo "[STEP 3] Installing Family Node Kit..."

DEST_DIR="$HOME/family-node-kit"

if [[ "$KIT_DIR" != "$DEST_DIR" ]]; then

    rm -rf "$DEST_DIR"

    mkdir -p "$(dirname "$DEST_DIR")"

    cp -a "$KIT_DIR" "$DEST_DIR"

    echo "✔ Installed to:"
    echo "  $DEST_DIR"

else

    echo "✔ Family Node Kit already installed"

fi

KIT_DIR="$DEST_DIR"
SYSTEM_DIR="$KIT_DIR/system/bin"

############################################
# 4. INITIALIZE FAMILY NODE KIT
############################################

echo "[STEP 4] Initializing Family Node Kit..."

bash "$SYSTEM_DIR/bootstrap.sh"

############################################
# 5. INSTALL ICON
############################################

echo
echo "[STEP 5] Installing icon..."

ICON_SRC="$KIT_DIR/desktop/icons/hicolor/48x48/apps/dashboard.png"
ICON_DST="$HOME/.local/share/icons/hicolor/48x48/apps/dashboard.png"

mkdir -p "$(dirname "$ICON_DST")"

cp "$ICON_SRC" "$ICON_DST"

chmod 644 "$ICON_DST"

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f -t \
        "$HOME/.local/share/icons/hicolor" || true
fi

touch "$HOME/.local/share/icons/hicolor"

echo "✔ Icon installed"

############################################
# 6. INSTALL DESKTOP ENTRY
############################################

echo
echo "[STEP 6] Installing desktop entry..."

mkdir -p "$HOME/.local/share/applications"

cp \
    "$KIT_DIR/desktop/family-node-dashboard.desktop" \
    "$HOME/.local/share/applications/"

update-desktop-database \
    "$HOME/.local/share/applications" 2>/dev/null || true

echo "✔ Desktop entry installed"

############################################
# 7. INSTALL DASHBOARD LAUNCHER
############################################

echo
echo "[STEP 7] Installing dashboard launcher..."

mkdir -p "$HOME/.local/bin"

cat > "$HOME/.local/bin/family-node-dashboard" <<'EOF'
#!/usr/bin/env bash

DASHBOARD="$HOME/family-node-kit/dashboard/bitcoin-dashboard.sh"

if [[ ! -f "$DASHBOARD" ]]; then
    echo "❌ Family Node Dashboard not found:"
    echo "   $DASHBOARD"
    exit 1
fi

exec bash "$DASHBOARD"
EOF

chmod +x "$HOME/.local/bin/family-node-dashboard"

echo "✔ Dashboard launcher installed"

############################################
# 8. INSTALL FAMILY-NODE COMMAND
############################################

echo
echo "[STEP 8] Installing family-node command..."

cp "$KIT_DIR/family-node" "$HOME/.local/bin/family-node"

chmod +x "$HOME/.local/bin/family-node"

echo "✔ family-node installed"

############################################
# 9. CHECK BITCOIN
############################################

echo
echo "[STEP 9] Checking Bitcoin..."

if [[ ! -d "$HOME/bitcoin" ]]; then

    echo
    echo "❌ Bitcoin is not installed."
    echo
    echo "Before Family Node Kit can be used,"
    echo "Bitcoin must be installed first."
    echo
    echo "STEP 1"
    echo "Open Terminal and Run:"
    echo
    echo "  bash ~/family-node-kit/tools/install-bitcoin.sh"
    echo
    echo "STEP 2"
    echo "Place the following files in:"
    echo
    echo "  ~/Downloads/bitcoin-verify/"
    echo
    echo "  • bitcoin-...x86_64-linux-gnu.tar.gz"
    echo "  • SHA256SUMS.txt"
    echo "  • SHA256SUMS.asc"
    echo
    echo "The installer will automatically:"
    echo "  ✔ Verify SHA256"
    echo "  ✔ Explain optional PGP verification"
    echo "  ✔ Install Bitcoin"
    echo
    echo "For more information about signatures and"
    echo "public keys, see:"
    echo
    echo "  DOCUMENTATIONS/GPG-VERIFYING-DOWNLOADS.md"
    echo

    exit 1
fi

############################################
# 10. START CORE STACK
############################################

echo
echo "[STEP 10] Starting system..."

bash "$SYSTEM_DIR/start-bitcoin-services.sh"

############################################
# 11. DONE
############################################

echo
echo "================================="
echo " INSTALLATION COMPLETE"
echo "================================="
echo
echo "Open Family Node Dashboard"
echo
echo "from the Applications menu or desktop launcher."
echo
echo "Done."
