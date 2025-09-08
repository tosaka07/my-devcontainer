#!/usr/bin/env bash
set -euo pipefail

REF="${REF:-master}"
TARGET_USER="${USERNAME:-${_REMOTE_USER:-vscode}}"

if id -u "$TARGET_USER" >/dev/null 2>&1; then
  if [ "$TARGET_USER" = "root" ]; then HOME_DIR="/root"; else HOME_DIR="/home/$TARGET_USER"; fi
else
  TARGET_USER="vscode"
  HOME_DIR="/home/vscode"
fi

echo "[bash-it] Installing for user: $TARGET_USER (home: $HOME_DIR) ref: $REF"

# Ensure git is available
if ! command -v git >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y && apt-get install -y --no-install-recommends git ca-certificates && rm -rf /var/lib/apt/lists/*
  fi
fi

install_dir="$HOME_DIR/.bash_it"
if [ ! -d "$install_dir" ]; then
  if [ "$TARGET_USER" = "root" ]; then SUDO_USER_CMD=""; else SUDO_USER_CMD=(sudo -u "$TARGET_USER"); fi
  "${SUDO_USER_CMD[@]}" git clone --depth 1 ${REF:+--branch "$REF"} https://github.com/Bash-it/bash-it.git "$install_dir"
  chown -R "$TARGET_USER":"$TARGET_USER" "$install_dir"
else
  echo "[bash-it] Already present at $install_dir; skipping clone"
fi

cat <<'EOF'
[bash-it] Installed. Activation is left to the user, e.g. add to ~/.bashrc:
  export BASH_IT="$HOME/.bash_it"
  [ -s "$BASH_IT/bash_it.sh" ] && source "$BASH_IT/bash_it.sh"
To enable plugins/themes, run commands inside the container as the user:
  bash-it enable plugin git
  bash-it enable completion ssh
  bash-it theme use bobby
EOF

