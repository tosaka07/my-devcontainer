#!/bin/bash
set -euo pipefail

echo "🤖 install-mcp: Start"

# Claude MCP setup
echo "   📦 Setting up Claude MCP servers..."

# Context 7 MCP for Claude
echo "      🔧 Adding Context 7 MCP to Claude..."
claude mcp add -s user context7 npx -- -y @upstash/context7-mcp || true

# Serena MCP for Claude
echo "      🔧 Adding Serena MCP to Claude..."
claude mcp add -s user serena uvx -- --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant --project $(pwd) --enable-web-dashboard false || true

# Gemini MCP setup
echo "   💎 Setting up Gemini MCP servers..."

# Context 7 MCP for Gemini
echo "      🔧 Adding Context 7 MCP to Gemini..."
gemini mcp add -s user context7 npx -- -y @upstash/context7-mcp || true

# Serena MCP for Gemini
echo "      🔧 Adding Serena MCP to Gemini..."
gemini mcp add -s user serena uvx -- --from git+https://github.com/oraios/serena serena-mcp-server --context ide-assistant --project $(pwd) --enable-web-dashboard false || true

echo "🤖 install-mcp: Done!"