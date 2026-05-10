-- Neovim 入口文件。
--
-- 这里故意保持极简，只负责把控制权交给 LazyVim 的启动逻辑。
-- 这样后续升级 LazyVim 或拆分配置时，入口层不会越来越乱。
require("config.lazy")
