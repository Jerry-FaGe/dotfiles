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

# 让交互式 zsh 也能继承 nvm 的默认 Node 版本。
export NVM_DIR="$HOME/.nvm"
if (( ! $+functions[nvm] )) && [[ -s "$NVM_DIR/nvm.sh" ]]; then
  source "$NVM_DIR/nvm.sh"
fi
