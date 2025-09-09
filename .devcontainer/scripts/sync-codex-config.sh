#!/bin/bash
set -euo pipefail

echo "🔧 sync-codex-config: Start"

# ホストの .codex ディレクトリ
HOST_CODEX_DIR="/host-codex"

# コンテナ内の Codex 設定ディレクトリ
CONTAINER_CODEX_DIR="/home/vscode/.codex"

# Codex 設定のコピー
if [ -d "${HOST_CODEX_DIR}" ]; then
    echo "   📋 Syncing Codex configuration from host..."
    
    # .codex ディレクトリがなければ作成
    mkdir -p "${CONTAINER_CODEX_DIR}"
    
    # prompts ディレクトリ
    if [ -d "${HOST_CODEX_DIR}/prompts" ]; then
        echo "      📁 Copying prompts..."
        cp -r "${HOST_CODEX_DIR}/prompts" "${CONTAINER_CODEX_DIR}/" 2>/dev/null || true
    fi
    
    # scripts ディレクトリ
    if [ -d "${HOST_CODEX_DIR}/scripts" ]; then
        echo "      📁 Copying scripts..."
        cp -r "${HOST_CODEX_DIR}/scripts" "${CONTAINER_CODEX_DIR}/" 2>/dev/null || true
    fi
    
    echo "   ✅ Codex configuration synced successfully"
else
    echo "   ℹ️ Host Codex directory not found, skipping sync"
fi

echo "🔧 sync-codex-config: Done!"