#!/usr/bin/env sh

set -ev # -e使某一步错误则退出，-v打印结果便于debug

installer=install-tl
tlmgr=tlmgr

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  installer=install-tl-windows.bat
  tlmgr=tlmgr.bat
fi

# 替换profile中的模板字串
# 该脚本的第一个参数作为texlive的安装路径
# 由于路径中可能含有`/`、`\`、`:`，故使用`#`作为sed的分隔符，
# 同时提前把$tl_path中的`\`替换为`/`（即使是Windows，profile里面的路径分割符也是`/`）
# ${var//<pattern>/<substitution>}替换所有
# 这里也不使用sed的-i参数进行就地替换，因为MacOS上sed可能不是GNU sed，形式有点不一样
tl_path="$(source ci/pwd.sh)/.ci-dock/tl"
sed "s#\$TL_DIR#${tl_path//\\//}#g" ci/tl.profile > ci/texlive.profile

curl -sLO http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip
unzip -q install-tl.zip
mv install-tl-2* install-tl-dir
install-tl-dir/$installer --profile ci/texlive.profile

# 这里需要确保tlmgr在PATH中
# tlmgr所在目录取决于texlive.profile和操作系统
$tlmgr update --self --all --no-auto-install
$tlmgr install $(sed 's/\s*#.*//;/^\s*$/d' ci/texlive-packages)
