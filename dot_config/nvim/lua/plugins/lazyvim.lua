-- 这个文件专门用来覆写 LazyVim 核心层的选项。
--
-- 这里优先做“全局风格与体验”相关的事：
-- 1. 配色
-- 2. 默认工具行为
-- 3. 非语言特定的编辑体验

return {
  {
    "LazyVim/LazyVim",
    opts = {
      -- tokyo night 是 LazyVim 默认就支持、兼容性也非常稳定的配色。
      -- 先保持稳，再让你后续按喜好切换别的主题。
      colorscheme = "tokyonight",
    },
  },
}
