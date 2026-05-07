# 🏠 Dotfiles

> Managed by [chezmoi](https://chezmoi.io) | Cross-platform: WSL + Linux servers + (future) Arch

## Quick Start

```bash
# 1. Copy age key (one-time manual step)
mkdir -p ~/.config/chezmoi
echo "AGE-SECRET-KEY-xxxxx" > ~/.config/chezmoi/key.txt

# 2. One command to bootstrap
chezmoi init --apply https://github.com/Jerry_FaGe/dotfiles.git
```

## What's Included

| Component | Tool | Description |
|-----------|------|-------------|
| Shell | zsh + zinit (turbo) | Modular config, 8 plugins |
| Prompt | Starship | Cross-platform prompt |
| Editor | Neovim (LazyVim) | IDE-like experience |
| File Manager | yazi | Terminal file manager |
| Git UI | lazygit | TUI git client |
| Fuzzy Finder | fzf | Fuzzy everything |
| Modern CLI | lsd, bat, fd, ripgrep | Better ls/cat/find/grep |
| Smart CD | zoxide | cd replacement |
| Python | uv | Fast package manager |
| Node | nvm | Node version manager |

## Shell Modules

```
~/.config/zsh/
├── env.zsh          # PATH, EDITOR, NVM
├── options.zsh      # setopt config
├── history.zsh      # history settings
├── keys.zsh         # vi-mode keybindings
├── completion.zsh   # compinit, fzf config
├── plugins.zsh      # zinit plugin loading
├── aliases.zsh      # all aliases
├── functions.zsh    # custom functions
├── proxy.zsh        # proxy management (template)
└── prompt.zsh       # starship init
```

## Daily Operations

```bash
chezmoi edit ~/.config/zsh/aliases.zsh   # Edit a module
chezmoi diff                              # Preview changes
chezmoi apply                             # Apply changes
chezmoi update                            # Pull & apply from remote
chezmoi cd                                # Enter source dir for git ops
```

## Debugging

```sh
# Re-run all run_once_ scripts
chezmoi state delete-bucket --bucket=scriptState

# Re-run all run_onchange_ scripts
chezmoi state delete-bucket --bucket=entryState

# View template variables
chezmoi data

# See ignored files
chezmoi ignored

# Check current status
chezmoi status
```

## Architecture

```
chezmoi source (~/.local/share/chezmoi/)
├── .chezmoi.toml.tmpl          # Age encryption config
├── .chezmoidata/config.toml    # Public data (package lists)
├── .chezmoiignore              # Ignore patterns
├── .chezmoiremove              # Files to remove
├── .chezmoiexternal.toml       # External dependencies
├── .chezmoiscripts/            # Install & setup scripts
│   ├── run_once_before_00-cleanup.sh
│   ├── run_onchange_before_10-install-apt.sh
│   ├── run_onchange_before_20-install-tools.sh
│   └── run_once_before_30-setup-shell.sh
├── dot_zshrc.tmpl              # Main entry point
└── dot_config/
    ├── zsh/                    # 10 shell modules
    └── starship.toml           # Prompt config
```

## Adding Proxy Config

To configure a proxy server for all machines:

```bash
# Create plaintext data
cat > /tmp/private.toml << 'EOF'
[proxy]
server_ip = "your.proxy.ip"
port = "29234"
EOF

# Encrypt
age -r age1xxxxx -o ~/.local/share/chezmoi/.chezmoidata/private.toml.age /tmp/private.toml
rm /tmp/private.toml

# Re-apply
chezmoi apply
```
