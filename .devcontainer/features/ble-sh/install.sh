#!/usr/bin/env bash
set -euo pipefail

# Options are exposed as uppercased env vars by the features engine
REF="${REF:-v0.4.0}"
TARGET_USER="${USERNAME:-${_REMOTE_USER:-vscode}}"

if id -u "$TARGET_USER" >/dev/null 2>&1; then
  if [ "$TARGET_USER" = "root" ]; then HOME_DIR="/root"; else HOME_DIR="/home/$TARGET_USER"; fi
else
  # Fallback to vscode if provided user does not exist yet
  TARGET_USER="vscode"
  HOME_DIR="/home/vscode"
fi

echo "[ble-sh] Installing for user: $TARGET_USER (home: $HOME_DIR) ref: $REF"

# Ensure git is available (Ubuntu/Debian base assumed)
if ! command -v git >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*
  fi
fi

install_dir="$HOME_DIR/.local/share/blesh"
mkdir -p "$(dirname "$install_dir")"

if [ ! -d "$install_dir" ]; then
  # Clone ble.sh into the user's home without modifying configs
  if [ "$TARGET_USER" = "root" ]; then SUDO_USER_CMD=""; else SUDO_USER_CMD=(sudo -u "$TARGET_USER"); fi
  "${SUDO_USER_CMD[@]}" git clone --depth 1 ${REF:+--branch "$REF"} https://github.com/akinomyoga/ble.sh.git "$install_dir"
  chown -R "$TARGET_USER":"$TARGET_USER" "$install_dir"
else
  echo "[ble-sh] Already present at $install_dir; skipping clone"
fi

cat <<'EOF'
[ble-sh] Installed. Activation is left to the user, e.g. add to ~/.bashrc:
  [ -s "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"
EOF

