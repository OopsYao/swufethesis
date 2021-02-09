% vim: set ft=latex:
\NeedsTeXFormat{LaTeX2e}
\LoadClass[scheme=plain,zihao=-4,fontset=none]{ctexbook}

% 用户接口设置
\RequirePackage{kvoptions}

\newcommand\swufesetup[1]{%
  \kvsetkeys{swufe}{#1}%
}

\RequirePackage{kvdefinekeys}
\newcommand{\swufe@@check}[2]{
  \@nameuse{ifswufe@#1@choicesenabled}%
  \@ifundefined{ifswufe@\@nameuse{swufe@#1@name}@#2}{\ClassError{swufethesis}{%
      Invalid value #2 for option #1%
    }{}}%
  % 将\ifswufe@<key>@<choice>置为true
  \@nameuse{swufe@\@nameuse{swufe@#1@name}@#2true}%
  \fi
}
% 这个内部命令用于设置用户接口
% 现支持设置name, choices
\newcommand{\swufe@define@key}[1]{%
  \kvsetkeys{swufe@key}{#1}
}
% 为每一个key设置handler
\kv@set@family@handler{swufe@key}{%
  \@namedef{swufe@#1@name}{#1} % name默认为key
  \kv@define@key{swufe@value}{name}{%
    % 用\swufe@<key>@name存储name的值
    \@namedef{swufe@#1@name}{##1}
  }

  \expandafter\newif\csname ifswufe@#1@choicesenabled\endcsname
  \kv@set@family@handler{swufe@choices}{%
    \@nameuse{ifswufe@#1@choicesenabled}\else%
    % 将第一个choice设为default
    \@namedef{swufe@\@nameuse{swufe@#1@name}}{##1}%
    \@nameuse{swufe@#1@choicesenabledtrue}%
    \fi
    % 为该choice设置一个if变量\ifswufe@<name>@<choice>
    % 用于后续的一些基于choices的设定
    \expandafter\newif\csname ifswufe@\@nameuse{swufe@#1@name}@##1\endcsname
  }
  \kv@define@key{swufe@value}{choices}{%
    \kvsetkeys{swufe@choices}{##1}
  }

  \kv@define@key{swufe@value}{default}{%
    \@namedef{swufe@\@nameuse{swufe@#1@name}}{##1}%
  }

  % 一些命令需要等用户通过swufesetup设置后运行才有效
  \@ifundefined{swufe@@#1@code}{\@namedef{swufe@@#1@code}{}}{}

  % 执行上面的handler
  \kvsetkeys{swufe@value}{#2}

  % 为外部用户使用的swufesetup设置handler
  \kv@define@key{swufe}{#1}{%
    \@namedef{swufe@\@nameuse{swufe@#1@name}}{##1}
    \swufe@@check{#1}{##1}
    \@nameuse{swufe@@#1@code}
  }
}
\newcommand{\swufe@option@hook}[2]{%
  \expandafter\g@addto@macro\csname swufe@@#1@code\endcsname{#2}%
}

% 将\month和\day转为两位数
\def\swufe@twodigits#1{\ifnum#1<10 0\fi\the#1}
\swufe@define@key{
  % 第多少届，默认值根据date选项设定
  % 例如2020年9月（含）至2021年9月（不含）设定为2017届
  index = {
      default = \swufe@date@format{\swufe@date}{\swufe@index@formatter}
    },
  date = {
      default = \the\year-\swufe@twodigits\month-\swufe@twodigits\day
    },
  title,
  author,
  school = {
      choices = {
          % 目前仅仅是作为choices的例子
          经济信息工程学院,
          经济数学学院,
        }
    },
  discipline,
  student-id = {
      name = student@id
    },
  supervisor,
}

% 将逗号分隔列表转为特定分隔符间隔的字串
\newcommand{\swufe@join@clist}[2]{%
  \def\swufe@tmp{}%
  % 列表的第二项开始将附带分隔符
  \newcommand{\swufe@clist@processor}[1]{%
    \ifx\swufe@tmp\@empty
      \def\swufe@tmp{#2}%
    \else
      #2%
    \fi
    ##1%
  }%
  \expandafter\comma@parse\expandafter{#1}{\swufe@clist@processor}
}

% 第一个参数是日期
% 第二个参数是一个宏（非宏的定义），接受年月日三个参数
\newcommand{\swufe@date@format}[2]{
  % 这里`\@nil`是参数表达式的一部分（一个常见的写法，本身无意义），
  % 用于标识参数的结束，否则最后的日期将只有一位数被纳入参数
  \def\swufe@@date@format@processor##1-##2-##3\@nil{
    #2{##1}{##2}{##3}
  }
  \expandafter\swufe@@date@format@processor#1\@nil
}
\newcommand{\swufe@date@zh@digit}[3]{
  #1年\number#2月\number#3日
}
\newcommand{\swufe@date@zh@digit@short}[3]{
  #1年#2月
}
% 将日期转化为相应的届数
\newcommand{\swufe@index@formatter}[3]{%
  \the\numexpr#1 - 4 \ifnum#2>8 + 1\fi % 若在这里使用\relax会使封面的届数数字后面多些空白（尚不清楚原理）
}

\RequirePackage{geometry}
\geometry{
  a4paper,
  left=3cm,
  top=3cm,
  right=3cm,
  bottom=3cm
}

% 文献引用，基于biblatex
% 采用gb7714-2015样式，以语言、作者、年份、标题、升序排列
% 见https://github.com/hushidong/biblatex-gb7714-2015/
\RequirePackage[style=gb7714-2015,sorting=gb7714-2015]{biblatex}

% 中文可换行下划线，文档见xeCJK
% 用于封面制作
\RequirePackage{xeCJKfntef}

\ctexset{
  autoindent = true,
  contentsname = 目录,
  listfigurename = 插图,
  listtablename = 表格,
  figurename = 图,
  tablename = 表,
  indexname = 索引,
  appendixname = 附录,
  bibname = 参考文献,
  chapter = {
    name = {,.},
    afterindent = true,
    aftername = \quad,
    format = \CJKfamily{hwzs}\fontsize{22bp}{1.5\dimexpr 15.6pt}\bfseries\centering\selectfont,
    titleformat = {},
    fixskip = true,
    % 这里需要说明的是，与chapter不同，section与subsection的beforeskip
    % 仅在前面为段落（非标题）时起作用
    % 而Word的策略是取段前段后最大的距离作为间距，这里由于二三级标题的要求是
    % 段前段后都为一行而恰好可以满足
    % 第二点是section与subsection的beforeskip作为页面的起始也是不生效的，
    % 这一点与Word相同，除非那个地方是一个新节（而一般仅在章这一层次使用分节符，
    % 从而与LaTeX的chapter吻合）
    % 下面chapter, section, subsection的beforeskip与afterskip皆是通过视觉效果调整
    beforeskip = 48pt,
    afterskip = 50pt,
   },
  section = {
    name = {,.},
    afterindent = true,
    format = \sffamily\fontsize{15bp}{1.5\dimexpr 15.6pt }\selectfont,
    fixskip = true,
    beforeskip = 30pt,
    afterskip = 30pt,
   },
  subsection = {
      name = {,.},
      afterindent = true,
      format = \sffamily\fontsize{12bp}{1.5\dimexpr 15.6pt}\selectfont,
      fixskip = true,
      beforeskip = 28pt,
      afterskip = 28pt,
    }
}

% 目录
\RequirePackage[titles]{tocloft} % 启用titles选项使其采用ctex对章节标题的设定来设置最上层标题
\renewcommand{\cftchapfont}{\bfseries} % 字号字体与正文相同故不再设置
% 目录单独成页
\let\swufe@tableofcontents\tableofcontents
\def\tableofcontents{\cleardoublepage\swufe@tableofcontents\pagenumbering{arabic}}

\RequirePackage{xparse}
% \swufe@chapter*[tocline]{title}
% 该命令是\chapter*的拓展，可将未编号的章节纳入目录
% 参数tocline表示该章节在目录中的条目，默认与title相同，留空表示不纳入目录
\NewDocumentCommand\swufe@chapter{s o m}{%
  \chapter*{#3}%
  \IfValueTF{#2}{%
    \ifthenelse{\equal{#2}{}}{}{%
      \addcontentsline{toc}{chapter}{#2}%
    }%
  }{\addcontentsline{toc}{chapter}{#3}}%
}

% 正文1.5倍行距
\renewcommand{\normalsize}{\fontsize{12bp}{1.5\dimexpr 15.6pt}\selectfont}

% 表格五号字体 单倍行距
\RequirePackage{caption}
\captionsetup{
  font={sf,bf,small}, % small在ctex zihao=-4下对应五号字 事实上并未规定表格标题字号
  justification=centering,
  labelsep=quad, % 标题编号与标题文字间隔一个quad
  aboveskip=0.5\baselineskip,
  belowskip=0.5\baselineskip,
  parskip=0.5\baselineskip, % 段落间距
}
% 修改图表编号格式为X-X
\renewcommand{\thetable}{\thechapter-\arabic{table}}
\renewcommand{\thefigure}{\thechapter-\arabic{figure}}
% 表格内容五号字单倍行距（字体未作规定）
\let\swufe@oldtable\table
\def\table[#1]{\swufe@oldtable[#1]\fontsize{10.5bp}{10.5bp}}

\RequirePackage{emptypage} % 使cleardoublepage添加的页面不含页码

% 关键词和摘要
\newcommand{\@keywords}[1]{\noindent\textbf{关键词：\swufe@join@clist{#1}{；}}}
\newcommand{\@@keywords}[1]{\noindent\textbf{Keywords: \swufe@join@clist{#1}{; }}}
\newenvironment{abstract}[1]{%
  \cleardoublepage
  \pagenumbering{arabic}
  \swufe@chapter*{摘要}
  \newcommand{\swufe@keywords}{#1}
}{%

  % 对于比较长的摘要，这里禁止断页后，LaTeX会优先调整段落间距来使关键词与最后一页摘要在同一页，
  % 可能会出现某一段落间距比普通的长一行的高度
  % （但一般是一页仅有两个段落时才会出现这种情况，多个段落会分摊这些间距）
  % TODO: 也许有方法可以让前一页提前断页，即这一行空白出现在前一页末尾而不是被段落间距分摊，这样也许会好看一点
  \nopagebreak
  \vspace{\baselineskip}
  \@keywords{\swufe@keywords}
}

\newenvironment{abstract*}[1]{%
  \cleardoublepage
  \pagenumbering{arabic}
  \swufe@chapter*{Abstract}
  \newcommand{\swufe@keywords@en}{#1}
}{%

  \nopagebreak
  \vspace{\baselineskip}
  \@@keywords{\swufe@keywords@en}
}

% 致谢
\newenvironment{acknowledgments}{%
  \swufe@chapter*{致谢}%
}{}

% 页码居中
\RequirePackage{fancyhdr}
\fancypagestyle{plain}{%
  \fancyhf{}
  \fancyfoot[C]{\zihao{-5}\thepage} % 小五号阿拉伯数字
  \renewcommand{\headrulewidth}{0pt} % 取消页眉横线
}
\pagestyle{plain}

% 封面
\RequirePackage{graphicx}
\renewcommand{\maketitle}{%
  \cleardoublepage
  % 虽然规范上要求上下左右页边距为3cm，但实际给出的封面与申明页模板采用的Word默认页边距
  % 为达到一致的视觉效果，对封面页和申明页使用特别的页边距，并在其他页面重置
  \newgeometry{
    vmargin=2.54cm,
    hmargin=3.18cm,
  }
  \thispagestyle{empty} % 取消页码
  \vspace*{-8pt}
  \noindent
  \includegraphics[width=10.35cm,height=2.88cm]{logo-Swufe.png}
  \vspace{64pt} % 根据视觉效果调整
  \begin{center}
    {
      % 黑体小初加粗
      \bfseries
      \xeCJKsetup{ CJKecglue = {\hskip 10pt} } % 届数数字与届之间的间距相较于Word来说过大，特别调整。Word的空格宽度应该是英文字体宽度
      \fontsize{36bp}{3\dimexpr 15.6pt}\selectfont
      \CJKfamily+{zhhei}
      \swufe@index 届\\
      本科毕业论文（设计）\par
      \xeCJKsetup{ CJKecglue = { ~ } } % 还原成默认设置，见xeCJK文档的初始化设置（代码实现部分）
    }
    \vspace{66.5pt} % 根据视觉效果调整
    \CJKfamily+{zhfs}
    \noindent
    \fontsize{16bp}{2\dimexpr 15.6pt}\selectfont
    {
    % 三号 华文仿宋
    % 左侧加粗，右侧下划线
    \let\ep\expandafter
    % `\CJKunderline*`将不会跳过中文标点
    % `*`与`{`前那个`\ep`是为了消除`*`与`{`带来的位置影响
    \def\entry##1:##2 {{\bfseries ##1：}&{\CJKfamily+{hwfs}\ep\CJKunderline\ep*\ep{##2\hfill}} \\}
    \begin{tabular}{lp{252.1pt}}
      \entry 论文题目:\swufe@title{}
      \entry 学生姓名:\swufe@author{}
      \entry {所在学院}:\swufe@school{}
      \entry {专\hspace{2em}业}:\swufe@discipline{}
      \entry {学\hspace{2em}号}:\swufe@student@id{}
      \entry {指导教师}:\swufe@supervisor{}
      \entry {成\hspace{2em}绩}:{}
    \end{tabular}
    }
    \vspace{\fill}

    {
      \bfseries\swufe@date@format{\swufe@date}{\swufe@date@zh@digit@short}
    }
  \end{center}
}

% 版权申明
\newcommand{\statement}{
  \cleardoublepage
  \thispagestyle{empty} % 取消页码
  % 这里不设置vspace时第一行字将紧挨着页面的body部分（可设置geometry的showframe选项查看）
  % 没搞清原理
  % 这个数值是根据视觉效果调出来的
  \vspace*{-34pt}
  \begin{center}
    % 华文中宋 小二加粗
    \bfseries
    \CJKfamily{hwzs}
    \fontsize{18bp}{2\dimexpr 15.6pt}\selectfont
    西南财经大学\\
    本科毕业论文原创性及知识产权声明\par
  \end{center}
  \vspace{12.3pt} % 这个数值是根据视觉效果调出来的

  \fontsize{12bp}{1.4\dimexpr 15.6pt}\selectfont
  本人郑重声明：所呈交的毕业论文是本人在导师的指导下取得的成果，论文
  写作严格遵循学术规范。对本论文的研究做出重要贡献的个人和集体，均已在文
  中以明确方式标明。因本毕业论文引起的法律结果完全由本人承担。

  本毕业论文成果归西南财经大学所有。
  \vspace{2\dimexpr 15.6pt}

  特此声明
  \vspace{\fill}
  \begin{flushright}
    毕业论文作者签名：\hspace*{4em}

    作者专业：\hspace*{4em}

    作者学号：\hspace*{4em}

    \swufe@date@format{\swufe@date}{\swufe@date@zh@digit}
  \end{flushright}
  \restoregeometry
}

\RequirePackage{pdfpages}
\RequirePackage{filehook} % file hooks已可以由LaTeX core (2020/10/01)原生支持，这个宏包可提供兼容性
\AtEndDocument{%
  \cleardoublepage%
  \null\thispagestyle{empty}\newpage% 封底前面插入空白页保证封底在下
  \includepdf{backcover.pdf}%
}

\swufe@define@key{
  cjk-font = {
      name = cjk@font,
      choices = {
          auto,
          windows,
          mac,
          noto,
          fandol,
          none,
        }
    }
}


% 判断操作系统，这是判断字体方案自动选取的依据之一
\newif\ifswufe@system@windows
\newif\ifswufe@system@mac
\newif\ifswufe@system@unix
\IfFileExists{/System/Library/Fonts/Menlo.ttc}{%
  \swufe@system@mactrue%
}{%
  \IfFileExists{/dev/null}{%
    \IfFileExists{null:}{%
      \swufe@system@windowstrue%
    }{%
      \swufe@system@unixtrue%
    }
  }{%
    \swufe@system@windowstrue%
  }%
}

\xeCJKsetup{%
  AutoFakeBold = true
}

% fandol方案
\newcommand{\swufe@set@cjk@font@fandol}{%
  \setCJKmainfont{FandolSong}[
    Extension = .otf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
    ItalicFont = FandolKai-Regular,
  ]%
  \setCJKsansfont{FandolHei}[
    Extension = .otf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
  ]%
  \setCJKmonofont{FandolFang}[
    Extension = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhsong}{FandolSong}[
    Extension = .otf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
  ]%
  \setCJKfamilyfont{zhhei}{FandolHei}[
    Extension = .otf,
    UprightFont = *-Regular,
    BoldFont = *-Bold,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension = .otf,
    UprightFont = *-Regular,
  ]%
  % 为华文中宋与华文仿宋设置找不到字体时的fallback
  \def\swufe@hwfs@fallback{%
    \setCJKfamilyfont{hwfs}{FandolFang}[
      Extension = .otf,
      UprightFont = *-Regular,
    ]%
  }
  \def\swufe@hwzs@fallback{%
    \setCJKfamilyfont{hwzs}{FandolSong}[
      Extension = .otf,
      UprightFont = *-Regular,
      BoldFont = *-Bold,
    ]%
  }
}

% Noto方案
\newcommand{\swufe@set@cjk@font@noto}{%
  \setCJKmainfont{Noto Serif CJK SC}[
    UprightFont = * Light,
    BoldFont = * Bold,
    ItalicFont = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
  ]%
  \setCJKsansfont{Noto Sans CJK SC}[
    BoldFont = * Medium,
  ]%
  \setCJKmonofont{Noto Sans Mono CJK SC}%
  \setCJKfamilyfont{zhsong}{Noto Serif CJK SC}[
    UprightFont = * Light,
    BoldFont = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Noto Sans CJK SC}[
    BoldFont = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension = .otf,
    UprightFont = *-Regular,
  ]%
  \def\swufe@hwfs@fallback{%
    \setCJKfamilyfont{hwfs}{FandolFang}[
      Extension = .otf,
      UprightFont = *-Regular,
    ]%
  }
  \def\swufe@hwzs@fallback{%
    \setCJKfamilyfont{hwzs}{FandolSong}[
      Extension = .otf,
      UprightFont = *-Regular,
      BoldFont = *-Bold,
    ]%
  }
}

% mac方案
\newcommand{\swufe@set@cjk@font@mac}{%
  \setCJKmainfont{Songti SC}[
    UprightFont = * Light,
    BoldFont = * Bold,
    ItalicFont = Kaiti SC,
    BoldItalicFont = Kaiti SC Bold,
  ]%
  \setCJKsansfont{Heiti SC}[
    BoldFont= * Medium
  ]%
  \setCJKmonofont{STFangsong}
  \setCJKfamilyfont{zhsong}{Songti SC}[
    UprightFont = * Light,
    BoldFont = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Heiti SC}[
    UprightFont = * Light,
    BoldFont = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{STFangsong}%
  \setCJKfamilyfont{zhkai}{Kaiti SC}[
    BoldFont = * Bold
  ]%
  \def\swufe@hwzs@fallback{%
    \setCJKfamilyfont{hwzs}{Songti SC}[
      UprightFont = * Light,
      BoldFont = * Bold,
    ]%
  }
}

% windows方案
\newcommand{\swufe@set@cjk@font@windows}{%
  \xeCJKsetup{EmboldenFactor=3}%
  \setCJKmainfont{SimSun}[
    ItalicFont = KaiTi,
  ]%
  \setCJKsansfont{SimHei}%
  \setCJKmonofont{FangSong}%
  \setCJKfamilyfont{zhsong}{SimSun}%
  \setCJKfamilyfont{zhhei}{SimHei}%
  \setCJKfamilyfont{zhkai}{KaiTi}%
  \setCJKfamilyfont{zhfs}{FangSong}%
  \def\swufe@hwfs@fallback{%
    \setCJKfamilyfont{hwfs}{FangSong}%
  }
  \def\swufe@hwzs@fallback{%
    \setCJKfamilyfont{hwzs}{SimSun}%
  }
}


\swufe@option@hook{cjk-font}{%
  \@nameuse{swufe@set@cjk@font@\@nameuse{swufe@cjk@font}}%
  \ifswufe@cjk@font@none\else%
    \providecommand{\heiti}{\CJKfamily{zhhei}}
    \providecommand{\fangsong}{\CJKfamily{zhfs}}
    \providecommand{\songti}{\CJKfamily{zhsong}}
    \providecommand{\kaishu}{\CJKfamily{zhkai}}
  \fi
}

% auto方案 根据一些条件从上述方案中自动选取
\newcommand{\swufe@set@cjk@font@auto}{%
  \newif\ifswufe@@font@setted% TODO: 多次使用swufesetup重置同一key时，其他的choice的真伪并未重置
  \ifswufe@system@mac%
    \IfFontExistsTF{Kaiti SC}{%
      \swufesetup{ cjk-font = mac }%
      \swufe@@font@settedtrue
    }{}%
  \fi
  \ifswufe@system@windows%
    \IfFontExistsTF{KaiTi}{%
      \swufesetup{ cjk-font = windows }%
      \swufe@@font@settedtrue
    }{}%
  \fi
  \ifswufe@system@unix%
    \IfFontExistsTF{Noto Serif CJK SC}{%
      \IfFontExistsTF{Noto Sans CJK SC}{%
        \swufesetup{ cjk-font = noto }%
        \swufe@@font@settedtrue
      }{}%
    }{}%
  \fi

  \ifswufe@@font@setted\else%
    % 以上方案均未设置，采用fandol方案
    \swufesetup{ cjk-font = fandol }%
  \fi
}

\swufesetup{ cjk-font = auto }

% 一级标题中的华文中宋与封面的华文仿宋属于硬性规定，独立于前面的cjk-font设定
% 如果找不到相应的字体会fallback至前面cjk-font
\IfFontExistsTF{STZhongsong}{%
  \setCJKfamilyfont{hwzs}{STZhongsong}%
}{\swufe@hwzs@fallback}

\IfFontExistsTF{STFangsong}{%
  \setCJKfamilyfont{hwfs}{STFangsong}%
}{\swufe@hwfs@fallback}

% 英文字体
\swufe@define@key{%
  font = {
      choices = {
          auto,
          times,
          termes,
        }
    }
}
\newcommand{\swufe@set@font@times}{%
  \setmainfont{Times New Roman}%
  \setsansfont{Arial}%
  \ifswufe@system@mac%
    \setmonofont{Menlo}%
  \else%
    \setmonofont{Courier New}%
  \fi
}
\newcommand{\swufe@set@font@termes}{%
  \setmainfont{texgyretermes}[
    Extension = .otf,
    UprightFont = *-regular,
    BoldFont = *-bold,
    ItalicFont = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setsansfont{texgyreheros}[
    Extension = .otf,
    UprightFont = *-regular,
    BoldFont = *-bold,
    ItalicFont = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setmonofont{texgyrecursor}[
    Extension = .otf,
    UprightFont = *-regular,
    BoldFont = *-bold,
    ItalicFont = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
}

\swufe@option@hook{font}{%
  \@nameuse{swufe@set@font@\@nameuse{swufe@font}}%
}
\newcommand{\swufe@set@font@auto}{%
  \ifswufe@system@unix%
    \IfFontExistsTF{texgyretermes-regular.otf}{%
      \swufesetup{ font = termes }%
    }{}%
  \else%
    % Windoes与mac采用times方案
    \swufesetup{ font = times }%
  \fi
}
\swufesetup{ font = auto }