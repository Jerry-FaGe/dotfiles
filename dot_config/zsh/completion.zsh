#######################################################
# Completion System
#######################################################

autoload -Uz compinit

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

ZCOMPDUMP="$ZSH_CACHE_DIR/.zcompdump-${HOST}-${ZSH_VERSION}"

compinit -d "$ZCOMPDUMP"

#######################################################
# Completion Style
#######################################################

# 大小写不敏感
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# 不强制菜单
zstyle ':completion:*' menu no

# 分组显示（给 fzf-tab 用）
zstyle ':completion:*:descriptions' format '[%d]'

# Docker 多短参数
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

#######################################################
# FZF
#######################################################

if (( ${+commands[fzf]} )); then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline-right'

  export FZF_CTRL_T_OPTS="
    --preview 'bat --color=always --style=numbers --line-range=:500 {}'
  "

  export FZF_ALT_C_OPTS="
    --preview 'lsd --tree --depth=2 --color=always {}'
  "

  local fzf_cache="$ZSH_CACHE_DIR/fzf.zsh"

  if [[ ! -s "$fzf_cache" || "$(command -v fzf)" -nt "$fzf_cache" ]]; then
    fzf --zsh >! "$fzf_cache"
  fi

  source "$fzf_cache"
fi
