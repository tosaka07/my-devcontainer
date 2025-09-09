#!/usr/bin/env bash
set -euo pipefail

echo "🔐 setup-ssh-agent.sh: Start"

# SSH エージェントソケットの権限を修正
if [ -S "/home/vscode/agent.sock" ]; then
  echo "    Fixing permissions for SSH agent socket..."
  sudo chown vscode:vscode /home/vscode/agent.sock || true
  echo "    SSH agent socket permissions fixed"
else
  echo "    ⚠️  SSH agent socket not found at /home/vscode/agent.sock"
  echo "    If you need SSH agent forwarding, ensure it's configured in devcontainer.json"
fi

echo "🔐 setup-ssh-agent.sh: Done!"

