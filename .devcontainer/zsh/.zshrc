###############################################
# Zsh init for this devcontainer
# - ユーザーが有効化を制御できるよう存在チェックのみ
###############################################

HISTSIZE=100000
SAVEHIST=100000
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt auto_pushd
setopt auto_cd
autoload -Uz compinit
compinit

# mise (tool shims)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# sheldon (plugin manager)
if command -v sheldon >/dev/null 2>&1; then
  eval "$(sheldon source)"
fi

# Atuin (history)
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

# Starship (prompt)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# eza aliases
if command -v eza >/dev/null 2>&1; then
  alias ls="eza"
  alias ll="eza -lF --time-style=long-iso"
  alias la="eza -laF --time-style=long-iso"
  alias lt="eza -T"
  alias lta="eza -T -a"
  alias tree="eza -TF"
fi
