% vim: set ft=latex:
\NeedsTeXFormat{LaTeX2e}
\LoadClass[scheme=plain,zihao=-4]{ctexbook}

% 用户接口设置
\RequirePackage{kvoptions}

\newcommand\swufesetup[1]{%
  \kvsetkeys{swufe}{#1}%
}

\RequirePackage{kvdefinekeys}
\newcommand{\swufe@@check}[2]{
  \@nameuse{ifswufe@#1@choicesenabled}%
  \@ifundefined{ifswufe@#1@#2}{\ClassError{swufethesis}{%
      Invalid value #2 for option #1%
    }{}}%
  % 将\ifswufe@<key>@<choice>置为true
  \@nameuse{swufe@#1@#2true}%
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
    % 为该choice设置一个if变量\ifswufe@<key>@<choice>
    % 用于后续的一些基于choices的设定
    \expandafter\newif\csname ifswufe@#1@##1\endcsname
  }
  \kv@define@key{swufe@value}{choices}{%
    \kvsetkeys{swufe@choices}{##1}
  }

  \kv@define@key{swufe@value}{default}{%
    \@namedef{swufe@\@nameuse{swufe@#1@name}}{##1}%
  }

  % 执行上面的handler
  \kvsetkeys{swufe@value}{#2}

  % 为外部用户使用的swufesetup设置handler
  \kv@define@key{swufe}{#1}{%
    \@namedef{swufe@\@nameuse{swufe@#1@name}}{##1}
    \swufe@@check{#1}{##1}
  }
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
\newcommand{\swufe@index@formatter}[3]{
  \the\numexpr#1 - 4 \ifnum#2>8 + 1\fi\relax
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
    format = \fontsize{22bp}{33bp}\bfseries\centering\selectfont,
    titleformat = {},
    beforeskip = 3\baselineskip,
    afterskip = 2\baselineskip,
   },
  section = {
    name = {,.},
    afterindent = true,
    format = \sffamily\fontsize{15bp}{22.5bp}\selectfont,
    beforeskip = \baselineskip,
    afterskip = \baselineskip,
   },
  subsection = {
      name = {,.},
      afterindent = true,
      format = \sffamily\fontsize{12bp}{18bp}\selectfont,
      beforeskip = \baselineskip,
      afterskip = \baselineskip,
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
\renewcommand{\baselinestretch}{1.5}

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

  \@keywords{\swufe@keywords}
}

\newenvironment{abstract*}[1]{%
  \cleardoublepage
  \pagenumbering{arabic}
  \swufe@chapter*{Abstract}
  \newcommand{\swufe@keywords@en}{#1}
}{%

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
  \thispagestyle{empty} % 取消页码
  \noindent
  \includegraphics[scale=0.75]{logo-Swufe.png} % 貌似png图片不包含分辨率信息，需要手动指定 https://tex.stackexchange.com/questions/1625/how-to-make-images-appear-at-their-actual-size
  \vspace{46pt}
  \begin{center}
    {
      % 黑体小初加粗
      \zihao{-0}
      \heiti
      \bfseries
      \swufe@index 届\break
      本科毕业论文（设计）
    }

    \vspace{64pt}
    \zihao{3}
    {
    % 三号 华文仿宋
    % 左侧加粗，右侧下划线
    \let\ep\expandafter
    % `\CJKunderline*`将不会跳过中文标点
    % `*`与`{`前那个`\ep`是为了消除`*`与`{`带来的位置影响
    \def\entry##1:##2 {{\bfseries ##1：}&{\ep\CJKunderline\ep*\ep{##2\hfill}} \\}
    \begin{tabular}{lp{15em}}
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
      \fangsong\bfseries\swufe@date@format{\swufe@date}{\swufe@date@zh@digit@short}
    }
  \end{center}
}

% 版权申明
\newcommand{\statement}{
  \cleardoublepage
  \thispagestyle{empty} % 取消页码
  \begin{center}
    % 华文中宋 小二加粗
    \bfseries
    \zihao{-2}
    西南财经大学\break
    本科毕业论文原创性及知识产权声明
  \end{center}

  \vspace{20pt}

  本人郑重声明：所呈交的毕业论文是本人在导师的指导下取得的成果，论文
  写作严格遵循学术规范。对本论文的研究做出重要贡献的个人和集体，均已在文
  中以明确方式标明。因本毕业论文引起的法律结果完全由本人承担。

  本毕业论文成果归西南财经大学所有。
  \vspace{\baselineskip}

  特此声明
  \vspace{\fill}
  \begin{flushright}
    毕业论文作者签名：\hspace*{4em}

    作者专业：\hspace*{4em}

    作者学号：\hspace*{4em}

    \swufe@date@format{\swufe@date}{\swufe@date@zh@digit}
  \end{flushright}
}

\RequirePackage{pdfpages}
\RequirePackage{filehook} % file hooks已可以由LaTeX core (2020/10/01)原生支持，这个宏包可提供兼容性
\AtEndDocument{%
  \cleardoublepage%
  \null\thispagestyle{empty}\newpage% 封底前面插入空白页保证封底在下
  \includepdf{backcover.pdf}%
}