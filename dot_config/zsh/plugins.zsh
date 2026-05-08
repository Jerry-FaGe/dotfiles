#######################################################
# Zinit Plugin Manager
#######################################################

# zinit 安装目录
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

[[ ! -f "$ZINIT_HOME/zinit.zsh" ]] && return 0

source "$ZINIT_HOME/zinit.zsh"

# 全局默认：静默加载
zinit ice lucid

#######################################################
# fzf-tab 配置（必须先定义 zstyle）
#######################################################

zstyle ':fzf-tab:*' fzf-flags \
  --height=60% \
  --layout=reverse \
  --border \
  --info=inline-right

zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':fzf-tab:complete:cd:*' \
  fzf-preview 'lsd --all --color=always --group-dirs=first $realpath'

zstyle ':fzf-tab:complete:__zoxide_z:*' \
  fzf-preview 'lsd --all --color=always --group-dirs=first $realpath'

zstyle ':fzf-tab:complete:(rm|trash):*' \
  fzf-preview 'ls -lh $word 2>/dev/null'

zstyle ':fzf-tab:complete:(vim|nvim|vi):*' \
  fzf-preview 'bat --color=always --style=numbers --line-range=:500 $word 2>/dev/null || cat $word 2>/dev/null'

#######################################################
# Layer 0 - Completion Critical
# 必须尽早加载
#######################################################

zinit ice wait'!' nocompinit

zinit light Aloxaf/fzf-tab
zinit light Freed-Wu/fzf-tab-source

#######################################################
# Layer 1 - Prompt Critical
# prompt 出现后立即异步
#######################################################

# fast syntax highlighting
zinit ice wait'0' atinit'FAST_HIGHLIGHT[theme]=default'
zinit light zdharma-continuum/fast-syntax-highlighting

# autosuggestions
zinit ice wait'0' atload'
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
'
zinit light zsh-users/zsh-autosuggestions

#######################################################
# Layer 2 - Interactive Enhancement
# 轻微延迟
#######################################################

# history substring search
zinit ice wait'1' atload'
  export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1

  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
  bindkey "^[OA" history-substring-search-up
  bindkey "^[OB" history-substring-search-down

  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down
'
zinit light zsh-users/zsh-history-substring-search

# forgit
zinit ice wait'1'
zinit light wfxr/forgit

#######################################################
# Layer 3 - Optional Utilities
# 最后加载
#######################################################

# fzf-git
zinit ice wait'2' has'fzf'
zinit light junegunn/fzf-git.sh

# you-should-use
zinit ice wait'2' atload'
  export YSU_MESSAGE_POSITION="after"
  export YSU_MODE="BESTMATCH"
'
zinit light MichaelAquilina/zsh-you-should-use

#######################################################
# Shell Integration Cache
#######################################################

ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$ZSH_CACHE_DIR"

# ---------- zoxide ----------

if (( ${+commands[zoxide]} )); then
  local cache="$ZSH_CACHE_DIR/zoxide.zsh"

  if [[ ! -s "$cache" || "$(command -v zoxide)" -nt "$cache" ]]; then
    zoxide init zsh >! "$cache"
  fi

  source "$cache"
fi

# ---------- uv ----------

if (( ${+commands[uv]} )); then
  local cache="$ZSH_CACHE_DIR/uv-completion.zsh"

  if [[ ! -s "$cache" || "$(command -v uv)" -nt "$cache" ]]; then
    uv generate-shell-completion zsh >! "$cache"
  fi

  source "$cache"
fi

# ---------- uvx ----------

if (( ${+commands[uvx]} )); then
  local cache="$ZSH_CACHE_DIR/uvx-completion.zsh"

  if [[ ! -s "$cache" || "$(command -v uvx)" -nt "$cache" ]]; then
    uvx --generate-shell-completion zsh >! "$cache"
  fi

  source "$cache"
fi
