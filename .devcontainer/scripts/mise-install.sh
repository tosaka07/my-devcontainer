#!/usr/bin/env bash
set -euo pipefail

echo "🪓 mise-install: Start"

# mise
if command -v mise >/dev/null 2>&1; then
  mise install -y || true
  echo "   Installed mise library!"
fi

echo "🪓 mise-install: Done!"
