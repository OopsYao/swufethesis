FROM ubuntu:20.04 AS build
# FROM mcr.microsoft.com/windows/servercore:ltsc2019-amd64

WORKDIR /repo

COPY . .

RUN apt-get update; apt-get install -y curl unzip perl libfontconfig

ENV PATH="/texlive/bin/x86_64-linux:${PATH}"

# Texlive layer
# A snapshot of specific packages on CTAN
RUN curl -sLO http://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip \
  && unzip -q install-tl.zip \
  && mv install-tl-2* install-tl-dir \
  && sed "s#\$TL_DIR#/texlive#g" tl.profile > texlive.profile \
  && install-tl-dir/install-tl --profile texlive.profile \
  && tlmgr update --self --all --no-auto-install --repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet \
  && tlmgr install $(sed 's/\s*#.*//;/^\s*$/d' texlive-packages) --repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet

FROM alpine:3.12.4
ENV PATH="/texlive/bin/x86_64-linux:$PATH"
COPY --from=build /texlive /texlive
