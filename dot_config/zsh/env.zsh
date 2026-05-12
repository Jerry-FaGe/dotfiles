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

# 用户级 zsh 补全目录
fpath=("$HOME/.local/share/zsh/site-functions" $fpath)

# uv 安装器生成的 env 脚本会补充用户级 PATH。
if [[ -f "$HOME/.local/bin/env" ]]; then
  source "$HOME/.local/bin/env"
fi

export EDITOR=nvim
export VISUAL=nvim
export SUDO_EDITOR=nvim
export FCEDIT=nvim

#######################################################
# GitHub API Token
#######################################################

# GitHub API 客户端通常读取 GITHUB_TOKEN/GH_TOKEN；chezmoi 也支持专用变量。
if command -v gh >/dev/null 2>&1; then
  _github_token="$(gh auth token --hostname github.com 2>/dev/null)"
  if [[ -n "$_github_token" ]]; then
    export GITHUB_TOKEN="${GITHUB_TOKEN:-$_github_token}"
    export GH_TOKEN="${GH_TOKEN:-$GITHUB_TOKEN}"
    export CHEZMOI_GITHUB_ACCESS_TOKEN="${CHEZMOI_GITHUB_ACCESS_TOKEN:-$GITHUB_TOKEN}"
  fi
  unset _github_token
fi

#######################################################
# fnm (Fast Node Manager)
#######################################################

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi
