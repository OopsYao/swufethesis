# SwufeTeX

[![Github Action test](https://img.shields.io/github/workflow/status/OopsYao/swufe-tex/CI?label=test&logo=github-actions&logoColor=white&style=flat-square)](https://github.com/OopsYao/swufe-tex/actions?query=workflow:CI+branch:main)
[![LPPL license](https://img.shields.io/badge/license-LPPL-008080?logo=latex&style=flat-square)](https://www.latex-project.org/lppl/)
[![Repo status](https://img.shields.io/badge/repo_status-WIP-dfb317?logo=github&style=flat-square)](https://www.repostatus.org/)

>  西南财经大学学位论文LaTeX模板
>
> LaTeX Thesis Template for Southwestern University of Finance and Economics

**:construction: 开发中...**

该项目旨在提供一个简单可用的西南财经大学学位论文LaTeX模板，包括本科毕业论文（设计）、硕士论文和博士论文。

## 如何安装

下载项目中的`swufethesis.cls`文件和`logo-Swufe.png`、`backcover.pdf`（本科生用），将它们放在LaTeX可感知的地方，如当前工作目录（运行latex程序的路径，一般是你的`.tex`文件所在目录）。

## 如何使用

项目提供了文档类`swufethesis`，可直接通过`\documentclass{swufethesis}`使用，并由`\swufesetup`命令设置学位类型、论文题目、作者等信息，可以参考项目里的`example.tex`文件。
