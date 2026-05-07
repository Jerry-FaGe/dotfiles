#######################################################
# 常用别名
#######################################################

alias c='clear'
alias q='exit'
alias ..='cd ..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if command -v lsd >/dev/null 2>&1; then
  alias ls='lsd -F --group-dirs first'
  alias ll='lsd --all --header --long --group-dirs first'
  alias la='lsd --almost-all --group-dirs first'
  alias l='lsd -F --group-dirs first'
  alias tree='lsd --tree'
else
  alias ls='ls --color=auto'
  alias ll='ls -alF --color=auto'
  alias la='ls -A --color=auto'
  alias l='ls -CF --color=auto'
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

if command -v ip >/dev/null 2>&1; then
  alias iplocal='ip -br -c a'
fi

if command -v curl >/dev/null 2>&1; then
  alias ipexternal='curl -fsSL ifconfig.me && echo'
fi
