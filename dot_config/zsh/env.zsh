#######################################################
# 路径与基础环境
#######################################################

# 用唯一数组管理 PATH，避免重复路径，并确保用户级工具优先。
typeset -U path PATH

pathprepend() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    path=("$dir" $path)
  done
}

pathappend() {
  local dir
  for dir in "$@"; do
    [[ -d "$dir" ]] || continue
    path+=("$dir")
  done
}

pathprepend "$HOME/.local/bin" "$HOME/bin" "$HOME/.bin"
pathappend "$HOME/.cargo/bin"

# uv 安装器生成的 env 脚本会补充用户级 PATH。
if [[ -f "$HOME/.local/bin/env" ]]; then
  source "$HOME/.local/bin/env"
fi

export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export FCEDIT=nvim

#######################################################
# fnm (Fast Node Manager)
#######################################################

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
