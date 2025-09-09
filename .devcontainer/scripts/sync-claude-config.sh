#!/bin/bash
set -euo pipefail

echo "🤖 sync-claude-config: Start"

# ホストの .claude ディレクトリをマウント（一時的に）
HOST_CLAUDE_DIR="/host-claude"

# コンテナ内の Claude 設定ディレクトリ
CONTAINER_CLAUDE_DIR="/home/vscode/.claude"

# ホストから設定ファイルをコピー
if [ -d "${HOST_CLAUDE_DIR}" ]; then
    echo "   📋 Syncing Claude configuration from host..."
    
    # commands ディレクトリ
    if [ -d "${HOST_CLAUDE_DIR}/commands" ]; then
        echo "      📁 Copying commands..."
        cp -r "${HOST_CLAUDE_DIR}/commands" "${CONTAINER_CLAUDE_DIR}/" 2>/dev/null || true
    fi
    
    # scripts ディレクトリ
    if [ -d "${HOST_CLAUDE_DIR}/scripts" ]; then
        echo "      📁 Copying scripts..."
        cp -r "${HOST_CLAUDE_DIR}/scripts" "${CONTAINER_CLAUDE_DIR}/" 2>/dev/null || true
    fi
    
    # settings.json ファイル
    if [ -f "${HOST_CLAUDE_DIR}/settings.json" ]; then
        echo "      📄 Copying settings.json..."
        cp "${HOST_CLAUDE_DIR}/settings.json" "${CONTAINER_CLAUDE_DIR}/" 2>/dev/null || true
    fi
    
    echo "   ✅ Claude configuration synced successfully"
else
    echo "   ℹ️ Host Claude directory not mounted, skipping sync"
fi

echo "🤖 sync-claude-config: Done!"