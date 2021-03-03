#!/usr/bin/env sh

set -e

# 这个脚本输出$PWD，但会在Git Bash (Windows)下会将路径转为Windows的格式
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  # 下面sed使用`|`作为分割符，并启用\(group capture\)
  # 先提取$PWD的盘符和其余部分
  disk=$(echo $PWD | sed 's|^/\([cd]\)/.*|\1|' | tr 'a-z' 'A-Z')
  after_disk=$(echo $PWD | sed 's|/[cd]/\(.*\)|\1|')
  # 再拼接并替换路径分隔符
  echo "$disk:/$after_disk" | sed 's|/|\\|g'
else
  echo $PWD
fi
