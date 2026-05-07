#######################################################
# 补全系统
#######################################################

# 先完成 compinit，再加载 fzf-tab，顺序必须正确。
autoload -Uz compinit
mkdir -p "$HOME/.cache/zsh"
compinit -d "$HOME/.cache/zsh/.zcompdump"

# 补全大小写不敏感，并复用 ls 颜色。
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no

if command -v dircolors >/dev/null 2>&1; then
  eval "$(dircolors -b)"
fi

if [[ -n "${LS_COLORS:-}" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi

# 为描述分组启用 fzf-tab 的分组显示。
zstyle ':completion:*:descriptions' format '[%d]'

# Docker 补全允许多个短选项堆叠。
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

#######################################################
# FZF 配置
#######################################################

if command -v fzf >/dev/null 2>&1; then
  export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --info=inline-right'
  export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
  export FZF_ALT_C_OPTS="--preview 'lsd --tree --depth=2 --color=always {}'"

  # 用 fzf 内置命令生成 shell 集成（>= 0.55.0），不依赖安装方式。
  source <(fzf --zsh)
fi
