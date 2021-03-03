#!/usr/bin/env sh

set -ev

for f in $(find \
  -path ./.ci-dock -prune -false \
  -or -name '*.tex' \
  -or -name '*.cls' \
  -or -name '*.bib'); do
  .ci-dock/indent/latexindent.pl -l "$f" | diff "$f" -
done
