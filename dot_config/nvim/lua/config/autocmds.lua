-- 这里放一些“和文件类型、界面行为相关”的自动命令。

local augroup = vim.api.nvim_create_augroup("jerry_fage_local", { clear = true })

-- 这些文本类文件默认启用换行和拼写检查，更接近写文档时的预期。
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "gitcommit", "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- 打开帮助页时放到右侧，更像一个随手可关的参考面板。
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "help", "man" },
  callback = function()
    vim.cmd.wincmd("L")
  end,
})
