#!/usr/bin/env sh

set -ev

for f in $(find \
  -path ./latexindent -prune -false \
  -or -name '*.tex' \
  -or -name '*.cls' \
  -or -name '*.bib'); do
  latexindent/latexindent.pl -l "$f" | diff "$f" -
done
