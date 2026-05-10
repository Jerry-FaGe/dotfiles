# LazyVim 速查表

这份表不是把所有功能列完，而是优先覆盖你现在最常用、最值得先记住的操作。

## 启动与基础

- 启动：`nvim`
- 打开目录：`nvim .`
- 打开指定文件：`nvim path/to/file`
- 保存：`Ctrl+s`
- 退出当前窗口：`:q`
- 强制退出：`:q!`
- 保存并退出：`:wq`

## 模式切换

- 普通模式进入插入模式：`i`
- 行尾插入：`A`
- 新起一行插入：`o`
- 退出插入模式：`Esc`
- 也可以用：`jk`

## 窗口与缓冲区

- 水平分屏：`<leader>-`
- 垂直分屏：`<leader>|`
- 关闭当前缓冲区：`<leader>bd`
- 切到左/下/上/右窗口：`Ctrl+h` / `Ctrl+j` / `Ctrl+k` / `Ctrl+l`
- 下一个缓冲区：`Shift+l`
- 上一个缓冲区：`Shift+h`

## 文件与搜索

- 找文件：`<leader><space>`
- 全局文本搜索：`<leader>/`
- 当前缓冲区搜索：`/关键词`
- 搜最近文件：`<leader>,`
- 打开文件浏览器：`<leader>e`

说明：
这里的 `<leader>` 默认是空格，所以 `<leader>e` 就是 `空格 e`。

## Git 常用

- 打开 LazyGit：终端里 `lazygit`
- 在编辑器里看 git hunk：`]h` / `[h`
- stage 当前 hunk：`<leader>ghs`
- reset 当前 hunk：`<leader>ghr`
- 预览 hunk：`<leader>ghp`

## LSP 常用

- 跳到定义：`gd`
- 跳到声明：`gD`
- 跳到实现：`gI`
- 查看引用：`gr`
- 查看文档：`K`
- 重命名符号：`<leader>cr`
- 代码动作：`<leader>ca`
- 格式化：`<leader>cf`

说明：
你这里启用了官方 `inc-rename` extra，所以 `<leader>cr` 是可预览的重命名，不是老式的一次性弹窗。

## 诊断与问题列表

- 下一条诊断：`]d`
- 上一条诊断：`[d`
- 当前行诊断浮窗：`<leader>cd`
- 打开问题列表：`<leader>xx`
- 打开当前文件诊断：`<leader>xX`

## 多光标前先学这几个替代动作

LazyVim 默认更偏 LSP + 文本对象，不是重度多光标流派。很多时候先用这些更稳：

- 改变量名：`<leader>cr`
- 结构性替换：`<leader>/`
- 当前文件替换：`:%s/旧/新/g`
- 精准编辑一段：可视模式选中后按 `c`

## 终端与命令行

- 打开终端：`<leader>ft`
- 终端模式返回普通模式：`Esc Esc`
- 进入命令行：`:`

## Python / TS / Docker 这台机子的重点能力

这台机子已经启用了这些官方 extras：

- Python
- Typescript
- Tailwind
- Docker
- JSON / TOML / YAML
- ESLint

意味着你在对应项目里通常会直接得到：

- LSP 跳转
- 诊断提示
- 自动补全
- Treesitter 高亮
- 部分 Mason 管理工具

## 插件管理

- 打开插件管理界面：`:Lazy`
- 更新插件：`:Lazy sync`
- 查看健康状态：`:LazyHealth`
- 查看整体健康：`:checkhealth`

## Mason 工具管理

- 打开 Mason：`:Mason`
- 安装/检查语言工具状态：在界面里看即可

## 你现在最值得先记住的 10 个键

- `空格 空格`：找文件
- `空格 /`：全局搜索
- `gd`：跳定义
- `gr`：看引用
- `K`：看文档
- `空格 c r`：重命名
- `空格 c a`：代码动作
- `空格 c f`：格式化
- `空格 e`：文件树/浏览
- `Ctrl+s`：保存

## 推荐上手顺序

1. 先只记文件搜索、跳定义、重命名、格式化
2. 再开始用问题列表和 git hunk
3. 最后再碰 `:Lazy`、`:Mason`、更细的插件层配置

## 这份配置里你自己改东西时，优先改哪

- 编辑器选项：`lua/config/options.lua`
- 快捷键：`lua/config/keymaps.lua`
- 自动命令：`lua/config/autocmds.lua`
- 官方 extras 开关：`lua/plugins/extras.lua`
- 主题与全局体验：`lua/plugins/lazyvim.lua`
- Treesitter/UI 微调：`lua/plugins/editor.lua`
- Mason 工具安装：`lua/plugins/tools.lua`
