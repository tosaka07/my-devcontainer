# my-devcontainer

Coding Agent による開発体験を最小構成で整える Dev Container テンプレートです。mise によるツール管理、共有ボリュームでのキャッシュ・履歴管理、zsh + sheldon による快適なシェル環境を備え、短時間で再現可能な環境を提供します。

## 要件

- Docker / VS Code + Dev Containers 拡張（または `devcontainer` CLI）

## クイックスタート

### このリポジトリで直接試す

1. VS Code でこのリポジトリを開き「Reopen in Container」。または:

```bash
# このリポジトリのルートで実行
devcontainer up --workspace-folder .
```

2. コンテナ内でツールをインストール:

```bash
mise install
```

### 既存プロジェクトにこの設定を適用

別のプロジェクトでこの Dev Container 設定を使用したい場合:

```bash
# 例: ~/my-project に適用する場合
cd ~/my-project
devcontainer up \
  --workspace-folder . \
  --config ~/path/to/my-devcontainer/.devcontainer/devcontainer.json
```

または VS Code の設定:
1. 対象プロジェクトを開く
2. `.vscode/settings.json` に以下を追加:
   ```json
   {
     "dev.containers.defaultConfigurationFile": "~/path/to/my-devcontainer/.devcontainer/devcontainer.json"
   }
   ```
3. 「Reopen in Container」を実行

## 特徴

### 🛠️ mise - ツール管理とキャッシュ

共通ライブラリを mise で管理し、named volume でキャッシュを共有。プロジェクトが既に `mise.toml` でツール管理している場合は、`mise install` だけで必要なツールがすべて自動インストールされます。

- **設定ファイル**: 
  - `.devcontainer/mise/config.toml`: グローバルツール（fzf, ripgrep, rust, starship, atuin など）
  - `mise.toml`: プロジェクト固有のツール（既存プロジェクトの場合はそのまま利用可能）
- **ツール追加**:
  ```bash
  # グローバルツールの追加
  mise use -g <tool>@<version>  # 例: mise use -g node@20
  
  # プロジェクトツールの追加
  mise use <tool>@<version>     # 例: mise use python@3.12
  ```
- **キャッシュ**: `/mnt/mise-data` (named volume: `mise-data-volume`)

### 🐚 zsh - カスタマイズ可能なシェル環境

sheldon でプラグインを管理し、atuin でコンテナ間のシェル履歴を共有。

- **プラグイン設定**: `.devcontainer/sheldon/plugins.toml`
- **プラグイン追加**:
  ```toml
  # plugins.toml に追加
  [plugins.example-plugin]
  github = "username/repo"
  ```
- **履歴共有**: atuin (named volume: `atuin-data-volume`)
  ```bash
  # 履歴検索
  Ctrl+R  # インタラクティブ検索
  ```

### 🔒 Firewall - セキュリティ強化

Claude Code のセキュリティ強化のため、アウトバウンド通信を制限。

- **設定ファイル**: `.devcontainer/scripts/init-firewall.sh`
- **許可ドメイン追加**:
  ```bash
  # init-firewall.sh の for domain セクションに追加
  for domain in \
    "example.com" \  # 新規追加
    "registry.npmjs.org" \
    # ...
  ```

### 🤖 Claude Code

設定を named volume で管理するため、一度ログインすれば別コンテナでも再ログイン不要。

- **設定**: `~/.claude` (named volume: `claude-code-config`)
- **使用方法**:
  ```bash
  claude --help
  ```

### 💻 Codex CLI

OpenAI Codex の設定も同様に mount で共有。

- **設定**: `~/.codex` (named volume: `codex-config`)
- **使用方法**:
  ```bash
  codex --help
  ```

### ✨ Gemini CLI (Vertex AI)

Google Cloud (Vertex AI) 経由で使用。gcloud 認証情報も共有されます。

- **設定**: `~/.config/gcloud` (named volume: `gcloud-config`)
- **初期設定**:
  ```bash
  # 認証
  gcloud auth application-default login
  
  # Gemini CLI 使用
  gemini --help
  ```

### 🔑 Git - SSH エージェント転送

ホストの SSH エージェントに接続するため、Mac ユーザーは追加設定なしで commit/push が可能。1Password SSH Agent にも対応。

- **SSH Agent**: `/home/vscode/agent.sock` (ホストから転送)
- **確認**:
  ```bash
  ssh-add -l  # 登録済みの鍵を確認
  ```

### 🐙 GitHub CLI

認証情報を named volume で共有。

- **設定**: `~/.config/gh` (named volume: `gh-config`)
- **初回ログイン**:
  ```bash
  gh auth login
  ```

## よくあるカスタマイズ

### コマンドラインから機能を追加

`devcontainer up` 実行時に、外部から Feature や mount を追加できます:

```bash
devcontainer up \
  --additional-features='{"ghcr.io/duduribeiro/devcontainer-features/neovim:1": {}}' \
  --mount type=bind,source=~/.config/nvim,target=/home/vscode/.config/nvim \
  --workspace-folder .
```

### 設定ファイルでのカスタマイズ

- Feature の対象ユーザー: `devcontainer.json` の `features.*.username` を変更（例: `root`）。
- ワークスペースごとにキャッシュを分離: `mounts[].source` のボリューム名を `${localWorkspaceFolderBasename}` などを使って分割。
