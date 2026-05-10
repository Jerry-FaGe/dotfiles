-- Lazy.nvim 是 LazyVim 的插件管理器。
-- 官方 starter 就是通过这个文件引导整个插件系统启动。

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim 官方主配置。
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- 本地自定义插件和覆写都放到 lua/plugins 下，保持官方推荐结构。
    { import = "plugins" },
  },
  defaults = {
    -- 自定义插件默认在启动时加载。
    -- 这样配置更直观，也更适合刚开始维护 LazyVim 的阶段。
    lazy = false,

    -- LazyVim 官方建议保留 false。
    -- 许多插件虽然声明了 release 版本，但实际常常比主分支更旧，容易出兼容问题。
    version = false,
  },

  -- 首次安装时先确保至少能进一个有配色的界面。
  install = { colorscheme = { "tokyonight", "habamax" } },

  checker = {
    enabled = true,

    -- 不在启动时弹通知，避免把编辑器变成消息中心。
    notify = false,
  },

  performance = {
    rtp = {
      -- 关闭一些基本用不到的内置插件，减少启动负担。
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
