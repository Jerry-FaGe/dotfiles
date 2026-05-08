#######################################################
# ZSH 基础选项
#######################################################

# 输入目录名时自动 cd，例如输入 `..` 等价于 `cd ..`
setopt autocd

# 每次 cd 自动压入目录栈，可用 dirs / popd / pushd 管理历史目录
setopt auto_pushd

# 避免目录栈中出现重复路径
setopt pushd_ignore_dups

# 交换 cd +N / -N 的行为，更符合直觉地前后切换目录栈
setopt pushdminus

# 允许交互式 shell 中使用 # 注释
setopt interactivecomments

# 在 = 后自动展开路径，例如 foo=~/bar 会展开 ~
setopt magicequalsubst

# 补全时允许在单词中间补全，而不是只能在结尾
# 例如 git che|ckout 按 Tab 可补成 checkout
setopt completeinword

# glob 未匹配时保持原样，而不是报错
# 例如 rm *.tmp 在无匹配时不会报 no matches found
setopt nonomatch

# 文件名按数字自然排序（1 2 10，而不是 1 10 2）
setopt numericglobsort

# 后台任务完成时立即提示，而不是等到下次按回车
setopt notify
