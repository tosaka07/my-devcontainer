# Repository Guidelines

## プロジェクト構成とモジュール
- `.devcontainer/`: 開発コンテナ設定一式。`devcontainer.json`（Dev Containers 設定）、`Dockerfile`（Ubuntu ベース、TZ/locale/ユーザー設定）。
- `mise.toml`: ツール管理（例: Node のバージョン指定）。
- ルートには `README.md`, `LICENSE`。現時点でアプリ用の `src/` や `test/` は未配置（必要に応じて追加）。

## ビルド・実行・開発コマンド
- Dev Containers（推奨）
  - `devcontainer build --workspace-folder .`: 開発コンテナのイメージをビルド。
  - `devcontainer up --workspace-folder .`: 開発コンテナを起動（VS Code からも同等操作可）。
- Docker 直接利用
  - `docker build -f .devcontainer/Dockerfile -t my-devcontainer .`
  - `docker run --rm -it -v "$PWD":/workspaces -w /workspaces my-devcontainer bash`
- mise（ツール管理）
  - `mise install`: `mise.toml` に基づきツールを取得。
  - コンテナ内 `PATH` は `/mnt/mise-data/shims` を含むため追加設定は不要。

## コーディングスタイルと命名
- JSON: 2 スペースインデント、末尾カンマなし、キーはローワーケース。
- Dockerfile: 1 命令 1 目的、キャッシュを意識して順序最適化、不要なレイヤーを避ける。
- ファイル/ディレクトリ命名: ローワーケース + ハイフン（例: `sample-script.sh`）。
- ブランチ命名: `feat/...`, `fix/...`, `docs/...`。

## テスト方針
- 本リポジトリは開発環境（Dev Container）提供が主目的のためテストは未提供。
- 将来的にテンプレートやスクリプトを追加する場合は `test/` を作成し、スモークテスト + `make test` などで統一実行を推奨。

## コミットとプルリクエスト
- コミット: Conventional Commits を推奨（例: `docs: add README`）。種別: `feat`, `fix`, `docs`, `chore`, `refactor`, `ci`。短く現在形で要点を記述。
- PR: 目的/背景/変更点/動作確認手順を明記。必要に応じスクリーンショットやログを添付。関連 Issue をリンク。小さく分割し、Rebase で履歴を整える。

## セキュリティと設定のヒント
- 機密情報はコミットしない（環境変数やトークンはローカル/CI の安全な保管に）。
- `devcontainer.json` のボリューム `/mnt/mise-data` はツール用。権限は `postCreateCommand` で設定されるため手動変更不要。

