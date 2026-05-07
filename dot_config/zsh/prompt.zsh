#######################################################
# Prompt
#######################################################

# 使用 Starship 作为 prompt，配置文件走 ~/.config/starship.toml。
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
