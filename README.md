# 🏠 Dotfiles

> 一条命令，完整复刻我的开发环境。

基于 [chezmoi](https://chezmoi.io) 管理，适用于 **Debian/Ubuntu 系 Linux**（WSL2 + 服务器），仅支持 **amd64** 架构。

## 为什么需要这个

每次换机器或重装系统，手动配 zsh、装 CLI 工具、拷贝配置文件能花掉半天。这个仓库把所有东西声明化了——改一个版本号就是一次升级，`chezmoi apply` 就是一次部署。

**核心理念：**

- **声明式**：工具版本锁在 `.chezmoidata/config.toml`，改版本号 → apply → 自动升级
- **模块化**：zsh 配置拆成独立模块，按序加载；安装脚本按职责拆分
- **跨环境**：模板变量自动区分 WSL / 服务器，同一仓库适配不同环境
- **安全**：敏感信息（代理凭据等）用 age 加密，明文永不进 git

## 快速开始

### 方式一：使用 install.sh（推荐）

```bash
# 下载并执行安装脚本；如果缺少 age key，脚本会交互提示粘贴
curl -fsSL https://raw.githubusercontent.com/Jerry-FaGe/dotfiles/main/install.sh | bash
```

已有 age key 文件时可以直接传入，适合自动化部署：

```bash
curl -fsSL https://raw.githubusercontent.com/Jerry-FaGe/dotfiles/main/install.sh | bash -s -- --age-key-file /path/to/key.txt
```

`install.sh` 是对官方 `get.chezmoi.io` 的薄封装，支持 `--one-shot`（临时环境）、`--no-apply`（仅克隆不部署）、`--repo URL` 和 `--age-key-file PATH`。

### 方式二：直接使用 chezmoi

```bash
sh -c "$(curl -fsLS https://get.chezmoi.io)" -- init --apply Jerry-FaGe/dotfiles
```

> **前提条件**：
> - `git` 和 `curl`（大部分发行版预装，如果没有：`sudo apt install git curl`）
> - **仅支持 Debian/Ubuntu amd64**：安装脚本使用 apt + 硬编码 amd64 下载链接
> - 首次 apply 需要 age 密钥；使用 `install.sh` 时会自动引导配置

## 工具清单

### 通过 apt 安装（基础包）

[zsh](https://www.zsh.org/) · [tmux](https://github.com/tmux/tmux) · tree · [jq](https://jqlang.github.io/jq/) · [ncdu](https://dev.yorhel.nl/ncdu) · unzip · curl · wget · [git](https://git-scm.com/) · [gh](https://cli.github.com/) · htop · [btop](https://github.com/aristocratos/btop)

WSL 额外：xclip | 服务器额外：iotop

### 通过官方脚本安装（自动最新版）

| 工具 | 用途 |
|------|------|
| [**Starship**](https://starship.rs/) | 跨平台 prompt |
| [**uv**](https://github.com/astral-sh/uv) | Python 包管理（替代 pip） |
| [**zoxide**](https://github.com/ajeetdsouza/zoxide) | 智能 cd |
| [**zinit**](https://github.com/zdharma-continuum/zinit) | zsh 插件管理（turbo 模式） |

### 通过 GitHub release 安装（版本锁定）

| 工具 | 版本 | 用途 |
|------|------|------|
| [**fzf**](https://github.com/junegunn/fzf) | 0.72.0 | 模糊搜索 |
| [**age**](https://github.com/FiloSottile/age) | 1.2.0 | 文件加密 |
| [**eza**](https://github.com/eza-community/eza) | 0.23.4 | 现代 ls（图标 + Git 状态） |
| [**bat**](https://github.com/sharkdp/bat) | 0.26.1 | 现代 cat（语法高亮） |
| [**fd**](https://github.com/sharkdp/fd) | 10.4.2 | 现代 find |
| [**ripgrep**](https://github.com/BurntSushi/ripgrep) | 15.1.0 | 现代 grep |
| [**yazi**](https://github.com/sxyazi/yazi) | 26.5.6 | 终端文件管理器 |
| [**lazygit**](https://github.com/jesseduffield/lazygit) | 0.61.1 | Git TUI |
| [**lazydocker**](https://github.com/jesseduffield/lazydocker) | 0.25.2 | Docker TUI |
| [**Neovim**](https://neovim.io/) | 0.12.2 | IDE 级编辑器（[LazyVim](https://www.lazyvim.org/)） |
| [**fastfetch**](https://github.com/fastfetch-cli/fastfetch) | 2.62.1 | 系统信息 |
| [**fnm**](https://github.com/Schniz/fnm) | 1.39.0 | Node 版本管理 |
| [**tealdeer**](https://github.com/tealdeer-rs/tealdeer) | 1.8.1 | 简化版 man (tldr) |

**升级流程**：修改 `.chezmoidata/config.toml` 中的版本号 → `chezmoi apply` → 脚本自动比较版本 → 仅在版本不匹配时下载安装。

## Shell 架构

zsh 配置拆成独立模块，由 `dot_zshrc.tmpl` 按顺序 source：

```
~/.config/zsh/
├── env.zsh              # PATH、EDITOR、GitHub token 注入、fnm init
├── options.zsh          # setopt 行为配置
├── history.zsh          # 历史记录设置
├── keys.zsh             # vi-mode 按键绑定
├── completion.zsh       # compinit、zstyle、fzf 配置
├── plugins.zsh          # zinit 插件（turbo 加载）
├── aliases.zsh          # 所有别名（eza/bat/lazygit 等）
├── functions.zsh        # 自定义函数
├── proxy.zsh            # 代理管理（WSL 自动检测 / server source 密文）
├── proxy.private.zsh    # [加密] 代理凭据（age 解密，600 权限）
└── prompt.zsh           # Starship 初始化（缓存）
```

加载顺序很重要——completion 在插件前，prompt 在最后。

## 跨环境适配

`.chezmoi.toml.tmpl` 自动检测机器类型：

- **WSL**：内核字符串包含 `microsoft` → `machine_type = "wsl"`
- **Server**：无桌面环境 → `machine_type = "server"`
- **Desktop**：其他 → `machine_type = "desktop"`

首次 `chezmoi init` 时通过 `promptStringOnce` 确认，之后记住选择。

模板中按 `machine_type` 分支处理差异（apt 包、代理方式等）。

## 目录结构

```
~/.local/share/chezmoi/
├── .chezmoi.toml.tmpl                  # chezmoi 配置模板（age + machine_type）
├── .chezmoidata/
│   └── config.toml                     # 公开数据：apt 包列表 + 工具版本号
├── .chezmoitemplates/
│   └── install-tools-functions.sh.tmpl # 安装脚本公共函数
├── .chezmoiscripts/
│   ├── run_onchange_before_09-setup-gh-apt-repo.sh.tmpl  # GitHub CLI apt 源
│   ├── run_onchange_before_10-install-apt.sh.tmpl        # apt 包安装
│   ├── run_onchange_before_20-install-core-tools.sh.tmpl # Starship/uv/zoxide/zinit
│   ├── run_onchange_before_21-install-github-tools.sh.tmpl # GitHub release 二进制
│   ├── run_once_before_00-cleanup.sh.tmpl                # 清理旧工具残留
│   ├── run_once_before_30-setup-shell.sh.tmpl            # zsh 设为默认 shell
│   └── run_once_after_90-gh-auth.sh.tmpl                 # gh 登录引导
├── dot_zshrc.tmpl                      # zsh 入口
├── dot_config/
│   ├── zsh/                            # shell 模块 + 加密代理密文
│   ├── gh/                             # GitHub CLI 配置（git_protocol: ssh）
│   ├── lazygit/                        # lazygit 配置
│   ├── nvim/                           # Neovim (LazyVim) 配置
│   ├── starship.toml                   # Starship prompt 配置
│   ├── tealdeer/                       # tldr 配置
│   └── yazi/                           # yazi 文件管理器配置
├── .chezmoiignore                      # 忽略规则
├── .chezmoiremove                      # 清理旧目标文件
├── .chezmoiversion                     # 最低 chezmoi 版本要求 (2.70.0)
└── install.sh                          # 引导安装入口
```

### 脚本执行顺序

```
09-setup-gh-apt-repo  → 添加 GitHub CLI 官方 apt 源
10-install-apt        → apt 基础包（zsh/tmux/git/gh/btop 等）
20-install-core-tools → 官方脚本工具（Starship/uv/zoxide/zinit）
21-install-github-tools → GitHub release 二进制（fzf/eza/bat 等，仅 amd64）
30-setup-shell        → chsh 设置 zsh 为默认 shell
90-gh-auth            → gh 登录引导（检测 GH_TOKEN 或提示交互登录）
```

`run_onchange_` 脚本在内容变化时重新执行；`run_once_` 按内容哈希去重。

## 加密管理

敏感信息使用 [age](https://github.com/FiloSottile/age) 加密（chezmoi 原生支持）：

```
dot_config/zsh/encrypted_private_proxy.private.zsh.age
  → 解密后部署到 ~/.config/zsh/proxy.private.zsh（权限 600）
  → 包含代理服务器地址等凭据，由 proxy.zsh source 引用
```

密钥位置：`~/.config/chezmoi/key.txt`（不进 git，不进仓库）。

## 日常操作

```bash
chezmoi edit ~/.config/zsh/aliases.zsh   # 编辑配置
chezmoi diff                              # 预览变更
chezmoi apply                             # 应用变更
chezmoi update                            # 从远程拉取并应用
chezmoi cd                                # 进入源码目录
```

## 故障排除

**age 解密错误**

使用 `install.sh` 时推荐直接让脚本配置密钥：

```bash
./install.sh --age-key-file /path/to/key.txt
```

也可以手动检查：

```bash
# 检查密钥是否存在且格式正确
cat ~/.config/chezmoi/key.txt
# 确认 chezmoi 识别了加密配置
chezmoi data | grep -A2 age
```

**模板变量错误**

重新初始化（会重新提示 machine_type）：

```bash
chezmoi init --apply Jerry-FaGe/dotfiles
```

**安装脚本某个工具失败**

脚本会在结尾汇总所有失败项。修复后重新 apply：

```bash
chezmoi apply --force
```

**代理不通（WSL 环境）**

```bash
# 检查代理密文是否已解密部署
ls -la ~/.config/zsh/proxy.private.zsh
# 测试代理连通性
source ~/.config/zsh/proxy.zsh && proxy-on && curl -I https://github.com
```

**重新运行安装脚本**

```bash
# 重新运行 run_once_ 脚本
chezmoi state delete-bucket --bucket=scriptState
# 重新运行 run_onchange_ 脚本
chezmoi state delete-bucket --bucket=entryState
```

**GitHub CLI 未登录**

```bash
# 如果有 token 环境变量，gh 会自动使用
export GH_TOKEN="ghp_xxx"
gh auth status

# 否则交互登录
gh auth login
```

## License

MIT
