-- 这里集中声明需要通过 Mason 自动安装的开发工具。
--
-- 原则：
-- 1. 只装通用价值高的工具
-- 2. 不和项目级工具链冲突
-- 3. 把“开箱即用”优先级放高于“面面俱到”

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Lua / Neovim 自身
        "lua-language-server",
        "stylua",

        -- Shell
        "bash-language-server",
        "shellcheck",
        "shfmt",

        -- Web / JS / TS
        "prettier",

        -- Python
        "pyright",
        "ruff",

        -- Docker
        "hadolint",
      },
    },
  },
}
