-- 这里放“编辑体验层”的小幅增强。

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Treesitter 语法树是现代 Neovim 体验的基础之一。
      -- 这里把这台机子大概率会碰到的语法一次补齐。
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "css",
        "dockerfile",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "json5",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end,
  },

  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        -- 更偏向“命令面板 / 搜索面板”风格的现代化体验。
        layout = {
          preset = "default",
        },
      },
    },
  },
}
