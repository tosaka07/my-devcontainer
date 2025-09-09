# my-devcontainer

開発体験を最小構成で整える Dev Container テンプレートです。mise によるツール管理、共有ボリュームでのキャッシュ・履歴管理、zsh + sheldon による快適なシェル環境を備え、短時間で再現可能な環境を提供します。

## 要件

- Docker / VS Code + Dev Containers 拡張（または `devcontainer` CLI）

## クイックスタート

1. VS Code でリポジトリを開き「Reopen in Container」。または:

```
devcontainer up --workspace-folder .
```

2. コンテナ内でツールをインストール:

```
mise install
```

## 構成の要点

- `.devcontainer/devcontainer.json`: ベースイメージ、環境変数（TZ/LANG 等）、mounts、Feature を定義。
- `.devcontainer/mise/config.toml`: ユーザー向け mise 設定（fzf, ripgrep, rust, starship, atuin など）。`~/.config/mise/config.toml` に bind。
- `mise.toml`（リポジトリ直下）: プロジェクト固有のツール（例: node）。
- `.devcontainer/zsh/.zshrc`: zsh の初期化（mise, sheldon, atuin, starship）。
- `.devcontainer/sheldon/plugins.toml`: zsh プラグイン設定（autosuggestions / completions / syntax-highlighting）。

## 共有ボリュームとキャッシュ

- mise: `MISE_DATA_DIR=/mnt/mise-data` を named volume にマウント（ツールキャッシュ共有）。
- Atuin: `~/.local/share/atuin` を named volume にマウント（履歴共有）。

## ツールとシェル連携（zsh）

- Atuin: `.zshrc` に初期化例あり（`eval "$(atuin init zsh)"`）。
- zsh + sheldon: `.devcontainer/zsh/.zshrc` と `.devcontainer/sheldon/plugins.toml` を bind。
  - `eval "$(sheldon source)"` で autosuggestions/completions/syntax-highlighting を読み込み。

## よくあるカスタマイズ

- Feature の対象ユーザー: `devcontainer.json` の `features.*.username` を変更（例: `root`）。
- ワークスペースごとにキャッシュを分離: `mounts[].source` のボリューム名を `${localWorkspaceFolderBasename}` などを使って分割。

## コントリビュート

運用ルールは `AGENTS.md` を参照してください。
