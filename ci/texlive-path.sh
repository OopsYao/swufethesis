#!/usr/bin/env sh

set -ev

if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  # 下面sed使用`|`作为分割符
  echo "$(source ci/pwd.sh)/.ci-dock/tl/bin/win32" | sed 's|/|\\|g'
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo $PWD/.ci-dock/tl/bin/x86_64-darwin
else
  echo $PWD/.ci-dock/tl/bin/x86_64-linux
fi
