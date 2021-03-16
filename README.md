<div align="center">

# SwufeThesis

**:memo:西南财经大学学位论文LaTeX模板**

[![Github Action test](https://img.shields.io/github/workflow/status/OopsYao/swufethesis/Test?label=test&logo=github-actions&logoColor=white&style=flat-square)](https://github.com/OopsYao/swufethesis/actions?query=workflow:Test+branch:main)
[![LPPL license](https://img.shields.io/badge/license-LPPL-008080?logo=latex&style=flat-square)](https://github.com/OopsYao/swufethesis/blob/main/LICENSE)
[![Repo status](https://img.shields.io/badge/repo_status-WIP-dfb317?logo=github&style=flat-square)](https://www.repostatus.org/)
[![GitHub release](https://img.shields.io/github/v/release/OopsYao/swufethesis?include_prereleases&sort=semver&style=flat-square&logo=github)](https://github.com/OopsYao/swufethesis/releases)
[![open in Overleaf](https://img.shields.io/badge/open_in-Overleaf-47a141?style=flat-square&logo=overleaf&logoColor=white)](#overleaf)

[如何安装](#如何安装) •
[使用说明](#使用说明) •
[致谢](#致谢)
</div>

西南财经大学学位论文LaTeX模板（非官方），包括本科毕业论文（设计）、硕士论文和博士论文。
> Your paper makes no goddamn sense,
> but it's the most beautiful thing I have ever laid eyes on.

## 如何安装

SwufeThesis目前主要发布在[GitHub Release](https://github.com/OopsYao/swufethesis/releases)上，包含TDS安装包、免安装版本和示例文件等，用户可以根据自己的需要下载。

### Overleaf

[Overleaf](https://www.overleaf.com/)是一个在线的LaTeX编辑平台。点击下面的徽章以直接在Overleaf中打开。

[![open in Overleaf](https://img.shields.io/github/v/release/OopsYao/swufethesis?include_prereleases&sort=semver&style=for-the-badge&logo=overleaf&logoColor=white&label=Open)](https://swufethesis.netlify.app/overleaf?prerelease)

### 免安装版本

免安装版本里面包含有示例文件，除了`swufethesis`目录，其余皆属于示例文件，用户可以根据自己的需要删改。为了保持项目结构的清晰性，文档类`swufethesis.cls`及其支撑文件都放在了`swufethesis`目录，所以用户可能需要注意TeX的路径查找问题。

如果用户使用[latexmk](https://www.ctan.org/pkg/latexmk/)作为编译工具，那么只需在`main.tex`文件所在目录执行`latexmk`命令即可编译示例文件，我们已在`latexmkrc`文件中进行了一些简单的配置。否则可能需要把`swufethesis`目录里的文件移出来使用，或是修改`TEXINPUTS`等环境变量。

### 手动安装

下载TDS安装包后解压至任意TDS目录，如TEXMFHOME或TEXMFLOCAL。以TEXMFHOME目录为例，该目录一般是用户目录下的`texmf`路径，Mac系统是个例外，是用户目录下的`Library/texmf`路径。如果目录不存在的话直接创建即可。具体的目录可以根据下面的命令查询。

```shell
kpsewhich -var-value TEXMFHOME
```

TDS安装包里直接含有`tex`、`doc`以及`source`等目录，并没有更顶层的目录，但有些压缩软件在解压时会自动地添加一层顶层目录，这会导致不正确的安装，总之要保证最终安装之后的texmf目录下直接是`tex`等目录。

手动安装后如果需要更新，直接重新解压覆盖原来的文件即可。如果需要卸载，删除texmf目录下的`<tdsroot>/latex/swufethesis`子目录即可（这里`<tdsroot>`为`tex`、`doc`以及`source`）。注意不要直接删除texmf目录，可能有之前手动安装过的其他的宏包。

如果是安装到TEXMFLOCAL目录，安装或卸载后可能都需要用`mktexlsr`命令刷新缓存。

## 使用说明

SwufeThesis提供了文档类`swufethesis`，并由`\swufesetup`命令设置学位类型、论文题目、作者等信息，更详细的信息可以查阅文档以及示例文件等。

## 致谢

SwufeThesis借鉴了许多[tuna/thuthesis](https://github.com/tuna/thuthesis)的设计，也参考了[stone-zeng/fduthesis](https://github.com/stone-zeng/fduthesis)、[sukanka/LaTeX-SWUFE-Bachelor-Thesis](https://github.com/sukanka/LaTeX-SWUFE-Bachelor-Thesis)等项目，感谢他们的工作！:heart:
