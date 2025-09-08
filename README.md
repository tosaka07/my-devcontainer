# my-devcontainer

開発体験を最小構成で整える Dev Container テンプレートです。mise によるツール管理、共有ボリュームでのキャッシュ・履歴管理、ローカル Feature（ble.sh / Bash-it）を備え、短時間で再現可能な環境を提供します。

## 要件
- Docker / VS Code + Dev Containers 拡張（または `devcontainer` CLI）

## クイックスタート
1) VS Code でリポジトリを開き「Reopen in Container」。または:

```
devcontainer up --workspace-folder .
```

2) コンテナ内でツールをインストール:

```
mise install
```

## 構成の要点
- `.devcontainer/devcontainer.json`: ベースイメージ、環境変数（TZ/LANG 等）、mounts、Feature を定義。
- `.devcontainer/mise.toml`: ユーザー向け mise 設定（fzf, ripgrep, rust, starship, atuin など）。`~/.mise.toml` に bind。
- `mise.toml`（リポジトリ直下）: プロジェクト固有のツール（例: node）。
- `.devcontainer/bash/.bashrc`: Bash-it / ble.sh / Atuin のサンプル有効化（存在チェックのみ）。
- ローカル Feature: `./.devcontainer/features/ble-sh`, `./.devcontainer/features/bash-it`（インストールのみ、設定は不変更）。

## 共有ボリュームとキャッシュ
- mise: `MISE_DATA_DIR=/mnt/mise-data` を named volume にマウント（ツールキャッシュ共有）。
- Atuin: `~/.local/share/atuin` を named volume にマウント（履歴共有）。

## ツールとシェル連携（任意）
- Bash-it: `export BASH_IT="$HOME/.bash_it"; [ -s "$BASH_IT/bash_it.sh" ] && source "$BASH_IT/bash_it.sh"`
  - 例: `bash-it enable plugin git`, `bash-it theme use bobby`
- ble.sh: `[ -s "$HOME/.local/share/blesh/ble.sh" ] && source "$HOME/.local/share/blesh/ble.sh"`
- Atuin: `.bashrc` の `# eval "$(atuin init bash)"` のコメントを外すと有効化。

## よくあるカスタマイズ
- Feature の対象ユーザー: `devcontainer.json` の `features.*.username` を変更（例: `root`）。
- ワークスペースごとにキャッシュを分離: `mounts[].source` のボリューム名を `${localWorkspaceFolderBasename}` などを使って分割。

## コントリビュート
運用ルールは `AGENTS.md` を参照してください。
