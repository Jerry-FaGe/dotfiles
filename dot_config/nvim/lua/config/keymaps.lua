-- 这里只补少量高频键位。
-- 原则是：不打破 LazyVim 默认体系，只补真正能提升日常手感的动作。

local map = vim.keymap.set

-- 在插入模式里用 jk 快速回到普通模式，适合终端键盘习惯。
map("i", "jk", "<Esc>", { desc = "退出插入模式" })

-- 更接近 GUI 编辑器的存档肌肉记忆。
map({ "n", "i", "v" }, "<C-s>", "<Cmd>w<CR><Esc>", { desc = "保存文件" })

-- 快速关闭当前缓冲区。
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "关闭当前缓冲区" })

-- 在分屏之间移动时不需要再按两次 Ctrl-w。
map("n", "<C-h>", "<C-w>h", { desc = "切到左侧窗口" })
map("n", "<C-j>", "<C-w>j", { desc = "切到下方窗口" })
map("n", "<C-k>", "<C-w>k", { desc = "切到上方窗口" })
map("n", "<C-l>", "<C-w>l", { desc = "切到右侧窗口" })

-- 在终端模式下也能用 Esc Esc 快速返回普通模式。
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "终端模式返回普通模式" })
