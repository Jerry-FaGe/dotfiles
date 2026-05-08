#######################################################
# Prompt
#######################################################

# 使用 Starship 作为 prompt，配置文件走 ~/.config/starship.toml。
if (( ${+commands[starship]} )); then
  ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  mkdir -p "$ZSH_CACHE_DIR"

  local cache="$ZSH_CACHE_DIR/starship.zsh"

  if [[ ! -s "$cache" || "$(command -v starship)" -nt "$cache" ]]; then
    starship init zsh >! "$cache"
  fi

  source "$cache"
fi
