-- 这里集中声明官方 extras。
--
-- 这些 extras 都来自 LazyVim 官方文档，优先级高于自己手搓插件组合：
-- 1. 后续升级更稳
-- 2. 和 LazyVim 默认生态更兼容
-- 3. 文档、键位、健康检查都更统一

return {
  -- 常见配置文件与数据文件支持。
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- 当前这台开发机最常见的语言/场景。
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.tailwind" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- 前端项目里 ESLint 很常见，官方 extra 能把 LSP 与格式联动处理好。
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- 把 LSP rename 升级成可预览的增量重命名体验。
  { import = "lazyvim.plugins.extras.editor.inc-rename" },
}
