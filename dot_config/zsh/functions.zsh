#######################################################
# 自定义函数
#######################################################

# 退出 Yazi 时同步 shell 当前目录。
if command -v yazi >/dev/null 2>&1; then
  y() {
    local tmp cwd
    tmp="$(mktemp -t yazi-cwd.XXXXXX)" || return
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(<"$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
      builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

# 统一更新 zinit 管理的所有 zsh 插件。
zsh-plugins-update() {
  command -v zinit >/dev/null 2>&1 || return 1
  zinit update --all
  print 'Zinit plugins updated'
}
