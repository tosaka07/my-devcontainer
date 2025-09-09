# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 概要

開発体験を最小構成で整える Dev Container テンプレートリポジトリ。mise によるツール管理、共有ボリュームでのキャッシュ・履歴管理、zsh + sheldon による快適なシェル環境を提供。

## 開発環境のセットアップとコマンド

### 環境立ち上げ
```bash
# VS Code で開発コンテナを起動（推奨）
# 「Reopen in Container」を実行、または：
devcontainer up --workspace-folder .

# コンテナビルドのみ
devcontainer build --workspace-folder .
```

### ツール管理（mise）
```bash
# プロジェクトで定義されたツールをインストール
mise install

# 特定ツールのバージョン確認
mise list

# ツールの実行例
node --version
```

## アーキテクチャと構成

### ディレクトリ構造
- `.devcontainer/`: Dev Container 設定一式
  - `devcontainer.json`: コンテナ設定（マウント、環境変数、Features）
  - `Dockerfile`: Ubuntu ベースイメージ、日本語ロケール、mise インストール
  - `mise/config.toml`: グローバル mise 設定（fzf, ripgrep, rust, starship, atuin など）
  - `zsh/.zshrc`: zsh 初期化設定
  - `sheldon/plugins.toml`: zsh プラグイン（autosuggestions, completions, syntax-highlighting）
  - `scripts/postCreate.sh`: コンテナ作成後の初期化処理

### mise によるツール管理
- プロジェクト固有: `mise.toml`（リポジトリルート）
- ユーザーグローバル: `.devcontainer/mise/config.toml`（`~/.config/mise/config.toml` にバインド）
- データディレクトリ: `/mnt/mise-data`（named volume で共有）

### 共有ボリューム
- `mise-data-volume`: mise でインストールしたツールのキャッシュ
- `atuin-data-volume`: シェル履歴の永続化

### 環境変数
- `MISE_DATA_DIR=/mnt/mise-data`: mise データディレクトリ
- `MISE_CONFIG_DIR=/home/vscode/.config/mise`: mise 設定ディレクトリ
- `XDG_STATE_HOME`, `XDG_DATA_HOME`, `XDG_CONFIG_HOME`: XDG Base Directory

## コーディング規約

### 日本語でのコミュニケーション
プロジェクトのドキュメントやコメントは日本語を使用。

### インデント
- JSON/YAML: 2 スペース
- Shell scripts: 4 スペース

### 命名規則
- ファイル/ディレクトリ: kebab-case（例: `sample-script.sh`）
- ブランチ: `feat/...`, `fix/...`, `docs/...`

### コミットメッセージ
Conventional Commits を使用:
- `feat:` 新機能
- `fix:` バグ修正
- `docs:` ドキュメント
- `chore:` メンテナンス
- `refactor:` リファクタリング

## 開発時の注意事項

### 権限管理
- `postCreate.sh` で XDG ディレクトリの所有権を自動設定
- mise の state/data ディレクトリは自動的に作成・権限設定される

### カスタマイズポイント
- Feature 対象ユーザー変更: `devcontainer.json` の `features.*.username`
- ワークスペースごとのキャッシュ分離: `mounts[].source` のボリューム名を変更

### セキュリティ
- 機密情報はコミットしない
- 環境変数やトークンはローカル/CI の安全な保管場所に