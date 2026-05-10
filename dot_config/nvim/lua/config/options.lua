-- 这里放的是“在 LazyVim 默认值之上”的额外编辑器选项。
--
-- LazyVim 自己已经带了一套成熟默认值，所以这里不重复堆一大堆通用设置，
-- 只补这台 WSL 开发机真正能带来收益的部分。

-- 用系统剪贴板复制粘贴。
-- 这台机子已经装了 xclip，在 WSL 终端里直接和系统剪贴板互通会顺手很多。
vim.opt.clipboard = "unnamedplus"

-- 搜索时默认智能大小写：
-- 纯小写时忽略大小写；一旦输入大写就按大小写精确匹配。
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- 在长文档/代码文件里保留更多滚动上下文，减少“光标一动就丢参照”的感觉。
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- 新窗口默认放右边/下边，更符合大多数现代编辑器的直觉。
vim.opt.splitright = true
vim.opt.splitbelow = true

-- 对于 Markdown、日志和提交信息，开启更友好的自动换行体验。
vim.opt.wrap = false

-- 如果系统里有 zsh，就让 :terminal 和外部 shell 命令优先走 zsh。
if vim.fn.executable("zsh") == 1 then
  vim.opt.shell = "zsh"
end

-- LazyVim Python extra 官方支持通过这两个变量切换行为。
-- 这里保留较稳妥的组合：Pyright 负责类型分析，Ruff 负责 lint/quick fixes。
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"

-- ESLint extra 官方支持的自动格式开关。
-- 前端项目里如果存在 eslint 配置，就优先复用项目自己的规范。
vim.g.lazyvim_eslint_auto_format = true
