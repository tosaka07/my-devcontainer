bind 'set completion-ignore-case on'
bind 'TAB:menu-complete'
bind 'set show-all-if-ambiguous on'

###############################################
# Sample: mise, Starship, Bash-it, ble.sh
# - 有効化はユーザー制御。存在チェックのみ。
# - 調整はこのファイルで行ってください（Feature は設定を変更しません）。
###############################################

# mise（ツール/シムの有効化）
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate bash)"
fi

# Starship（プロンプト）。Bash-it のテーマと競合するため併用時は
# Bash-it 側のテーマを無効（theme 未設定）にすることを推奨。
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init bash)"
fi

# Bash-it
export BASH_IT="$HOME/.bash_it"
if [ -s "$BASH_IT/bash_it.sh" ]; then
  # 例: プラグイン/テーマはユーザー操作で有効化
  #   bash-it enable plugin git
  #   bash-it enable completion ssh
  #   bash-it theme use bobby   # Starship 使用時はテーマ未設定を推奨
  source "$BASH_IT/bash_it.sh"
fi

# ble.sh（インタラクティブ時のみ、最後に読み込むのが推奨）
if [[ $- == *i* ]]; then
  if [ -s "$HOME/.local/share/blesh/ble.sh" ]; then
    # 例: 一時的に無効化したい場合は次行をコメントアウト
    source "$HOME/.local/share/blesh/ble.sh"
  fi
fi

###############################################
# Sample: Enable Atuin (optional)
# - コマンド履歴は named volume で共有: ~/.local/share/atuin
# - 有効化はユーザー任意。必要なら次行のコメントを外してください。
###############################################
if command -v atuin >/dev/null 2>&1; then
  # eval "$(atuin init bash)"
  : # Atuin is installed via mise; run `atuin` manually or enable the line above
fi
