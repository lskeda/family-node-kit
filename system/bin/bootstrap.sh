#!/usr/bin/env bash
set -euo pipefail

echo "================================="
echo "     FAMILY NODE BOOTSTRAP"
echo "================================="
echo

############################################
# 1. CREATE DIRECTORIES
############################################

echo "[1/5] Creating system structure..."

mkdir -p "$HOME/.family-node-kit/env"
mkdir -p "$HOME/.family-node-kit"
mkdir -p "$HOME/.family-node"

echo "✔ Directories ready"

############################################
# 2. DEPENDENCY CHECK (NO INSTALL)
############################################

echo "[2/5] Checking dependencies..."

for bin in podman jq tar openssl; do
    if ! command -v "$bin" >/dev/null 2>&1; then
        echo "⚠ Missing: $bin"
    fi
done

echo "✔ Dependency check complete"

############################################
# 3. RPC CREDENTIALS
############################################

echo "[3/5] Ensuring RPC credentials..."

CFG="$HOME/.family-node-kit/env/rpc.env"

if [[ ! -f "$CFG" ]]; then
    echo "Creating RPC credentials..."

    USER="rpc$(openssl rand -hex 3)"
    PASS="$(openssl rand -base64 32)"

    cat > "$CFG" <<EOF
RPC_USER=$USER
RPC_PASS=$PASS
EOF

    chmod 600 "$CFG"
    echo "✔ RPC credentials created"
else
    echo "✔ RPC credentials exist"
fi

############################################
# 4. STATE FILE (NEW CORE SYSTEM)
############################################

echo "[4/5] Initializing system state..."

STATE="$HOME/.family-node-kit/state.env"

if [[ ! -f "$STATE" ]]; then
cat > "$STATE" <<EOF
BITCOIN_INSTALLED=0
BITCOIN_VERIFIED=0
FULCRUM_INSTALLED=0
FULCRUM_RUNNING=0
TOR_ENABLED=0
EOF
    echo "✔ State initialized"
else
    echo "✔ State already exists"
fi

############################################
# 5. FINALIZATION
############################################

echo "[5/5] Bootstrap complete"

echo
echo "================================="
echo " BOOTSTRAP COMPLETE"
echo "================================="
echo
echo "System is ready for onboarding."
echo
echo "Next step:"
echo "  install Bitcoin (verify-first)"
echo "================================="
