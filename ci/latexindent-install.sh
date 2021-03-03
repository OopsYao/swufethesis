#!/usr/bin/env sh

set -ev

curl -sOL http://mirrors.ctan.org/support/latexindent.zip
unzip -q latexindent.zip
mv latexindent .ci-dock/indent
