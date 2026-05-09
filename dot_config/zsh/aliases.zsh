#######################################################
# 常用别名
#######################################################

alias c='clear'
alias q='exit'
alias ..='cd ..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons=always --group-directories-first'
  alias ll='eza --all --header --long --icons=always --group-directories-first'
  alias la='eza --almost-all --icons=always --group-directories-first'
  alias l='eza --icons=always --group-directories-first'
  alias tree='eza --tree --icons=always'
fi

if command -v nvim >/dev/null 2>&1; then
  alias vi='nvim'
  alias vim='nvim'
  alias svi='sudo nvim'
elif command -v vim >/dev/null 2>&1; then
  alias vi='vim'
  alias svi='sudo vim'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'
fi

if command -v lazydocker >/dev/null 2>&1; then
  alias lzd='lazydocker'
fi

if command -v tldr >/dev/null 2>&1; then
  alias man='tldr'
fi

if command -v ip >/dev/null 2>&1; then
  alias iplocal='ip -br -c a'
fi

if command -v curl >/dev/null 2>&1; then
  alias ipexternal='curl -fsSL ifconfig.me && echo'
fi
