#######################################################
# Zinit 插件管理（替代 Sheldon）
#######################################################

# 确保 zinit 已安装
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -f "$ZINIT_HOME/zinit.zsh" ]]; then
  return 0
fi

source "$ZINIT_HOME/zinit.zsh"

# --- Turbo 模式插件（prompt 渲染后异步加载） ---

# fzf-tab：fzf 补全界面
# wait'!' = 立即加载（阻塞），因为必须在 compinit 之后、其他包裹 widget 的插件之前
zinit ice wait'!' lucid atload'zstyle ":fzf-tab:*" fzf-flags --height=60% --layout=reverse --border --info=inline-right
zstyle ":fzf-tab:*" switch-group "<" ">"
zstyle ":fzf-tab:complete:cd:*" fzf-preview "lsd --all --color=always --group-dirs=first \$realpath"
zstyle ":fzf-tab:complete:__zoxide_z:*" fzf-preview "lsd --all --color=always --group-dirs=first \$realpath"
zstyle ":fzf-tab:complete:(rm|trash):*" fzf-preview "ls -lh \$word 2>/dev/null"
zstyle ":fzf-tab:complete:(vim|nvim|vi):*" fzf-preview "bat --color=always --style=numbers --line-range=:500 \$word 2>/dev/null || cat \$word 2>/dev/null"'
zinit light Aloxaf/fzf-tab

# fzf-tab-source：社区预览配置集合，覆盖 244 个常用工具
zinit ice wait lucid
zinit light Freed-Wu/fzf-tab-source

# forgit：Git 交互式操作的 fzf 封装
zinit ice wait lucid
zinit light wfxr/forgit

# fast-syntax-highlighting：语法高亮
# 不用 turbo 模式，因为 fast-theme 需要立即可用
zinit light zdharma-continuum/fast-syntax-highlighting
autoload -Uz fast-theme 2>/dev/null && fast-theme base16 >/dev/null 2>&1

# zsh-history-substring-search：历史搜索
zinit ice wait lucid atload'
  export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey "^[OA" history-substring-search-up
  bindkey "^[OB" history-substring-search-down
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search

# zsh-autosuggestions：命令补建议
zinit ice wait lucid atload'export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"'
zinit light zsh-users/zsh-autosuggestions

# fzf-git：Git 对象的 fzf 快捷键
zinit ice wait lucid has'fzf'
zinit light junegunn/fzf-git.sh

# you-should-use：alias 提示（放在 alias 定义之后加载）
zinit ice wait lucid atload'
  export YSU_MESSAGE_POSITION="after"
  export YSU_MODE="BESTMATCH"
'
zinit light MichaelAquilina/zsh-you-should-use

#######################################################
# Shell 集成（compinit 之后初始化）
#######################################################

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi

if command -v uvx >/dev/null 2>&1; then
  eval "$(uvx --generate-shell-completion zsh)"
fi
