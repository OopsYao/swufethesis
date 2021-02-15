% vim: set ft=latex:
\NeedsTeXFormat{LaTeX2e}
\LoadClass[scheme=plain,zihao=-4,fontset=none]{ctexbook}

% 用户接口设置
\RequirePackage{kvoptions}

\newcommand\swufesetup[1]{%
  \kvsetkeys{swufe}{#1}%
}

\RequirePackage{kvdefinekeys}
% 这个foreach不能和其他的kvdefinekeys的handler嵌套（没有想象中的好用）
\newcommand{\swufe@foreach}[2]{
  \def\swufe@@foreach@family{swufe@foreach}%
  \kv@set@family@handler{\swufe@@foreach@family}{#2}%
  \expandafter\kvsetkeys\expandafter{\expandafter\swufe@@foreach@family\expandafter}\expandafter{#1}%
}
\newcommand{\swufe@@check}[2]{
  \@ifundefined{ifswufe@\@nameuse{swufe@#1@name}@#2}{\ClassError{swufethesis}{%
      Invalid value #2 for option #1%
    }{}}%
  % 重置所有\ifswufe@<name>@...为false，再将\ifswufe@<name>@<choice>置为true
  \edef\swufe@@choices{\@nameuse{swufe@#1@choices}}
  \swufe@foreach{\swufe@@choices}{%
    \@nameuse{swufe@\@nameuse{swufe@#1@name}@##1false}%
  }
  \@nameuse{swufe@\@nameuse{swufe@#1@name}@#2true}%
}
% 这个内部命令用于设置用户接口
% 现支持设置name, choices
\newcommand{\swufe@define@key}[1]{%
  \kvsetkeys{swufe@key}{#1}
}
% 为每一个key设置handler
\kv@set@family@handler{swufe@key}{%
  \@namedef{swufe@#1@name}{#1} % name默认为key
  \@namedef{swufe@#1@choices}{} % choices默认为空

  \kv@define@key{swufe@value}{name}{%
    % 用\swufe@<key>@name存储name的值
    \@namedef{swufe@#1@name}{##1}
  }

  \kv@set@family@handler{swufe@choices}{%
    % 为该choice设置一个if变量\ifswufe@<name>@<choice>
    % 用于后续的一些基于choices的设定
    \expandafter\newif\csname ifswufe@\@nameuse{swufe@#1@name}@##1\endcsname
  }
  \kv@define@key{swufe@value}{choices}{%
    \@namedef{swufe@#1@choices}{##1}
    \kvsetkeys{swufe@choices}{##1}
    \@namedef{swufe@#1@choices}{##1}
  }

  % 一些命令需要等用户通过swufesetup设置后运行才有效
  \@ifundefined{swufe@@#1@code}{\@namedef{swufe@@#1@code}{}}{}

  % 执行上面的handler
  \kvsetkeys{swufe@value}{#2}
  % 为\swufe@<name>定义空值，增加后面的容错性
  \@namedef{swufe@\@nameuse{swufe@#1@name}}{}
  % 为外部用户使用的swufesetup设置handler
  \kv@define@key{swufe}{#1}{%
    \@namedef{swufe@\@nameuse{swufe@#1@name}}{##1}
    \expandafter\ifx\csname swufe@#1@choices\endcsname\@empty\else%
      \swufe@@check{#1}{##1}%
    \fi%
    \@nameuse{swufe@@#1@code}
  }
}
\newcommand{\swufe@option@hook}[2]{%
  \expandafter\g@addto@macro\csname swufe@@#1@code\endcsname{#2}%
}

% 将\month和\day转为两位数
\def\swufe@twodigits#1{\ifnum#1<10 0\fi\the#1}
\swufe@define@key{
  index, % 第多少届
  date,
  title,
  title* = {
      name = title@en,
    },
  author,
  school,
  discipline,
  student-id = {
      name = student@id
    },
  supervisor,
  degree = {
      choices = {
          bachelor,
          master,
          doctor,
        }
    },
  degree-type = {
      name = degree@type,
      choices = {
          academic, % 学术型
          professional, % 专业型
          equivalent, % 同等学力
        }
    },
  secret-level = {
      name = secret@level,
    },
  secret-year = {
      name = secret@year,
    },
  clc, % 分类号
  udc,
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
\newcommand{\swufe@date@format}[2]{%
  % 这里`\@nil`是参数表达式的一部分（一个常见的写法，本身无意义），
  % 用于标识参数的结束，否则最后的日期将只有一位数被纳入参数
  \def\swufe@@date@format@processor##1-##2-##3\@nil{%
    #2{##1}{##2}{##3}
  }%
  \expandafter\swufe@@date@format@processor#1\@nil
}
\newcommand{\swufe@date@zh@digit}[3]{%
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
\swufe@option@hook{degree}{%
  \ifswufe@degree@bachelor%
    \geometry{
      a4paper,
      left=3cm,
      top=3cm,
      right=3cm,
      bottom=3cm,
    }
  \else%
    \geometry{
      a4paper,
      top=3.9cm,
      bottom=3.4cm,
      left=3.45cm,
      right=3.45cm,
      headsep=20pt,
      foot=21pt,
    }
  \fi
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

% Three matters
\renewcommand{\frontmatter}{%
  \cleardoublepage
  \@mainmatterfalse
  \pagenumbering{arabic}%
}
\renewcommand{\mainmatter}{%
  \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}%
}
\renewcommand{\backmatter}{%
  \ifswufe@output@check\end{document}\fi % 检测版直接结束
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse%
}

\swufe@define@key{
  output = {
      choices = {
          print,
          check, % 检测版
        }
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
\swufe@option@hook{degree}{%
  \ifswufe@degree@bachelor%
    \renewcommand{\normalsize}{\fontsize{12bp}{1.5\dimexpr 15.6pt}\selectfont}
  \else%
    \renewcommand{\normalsize}{\fontsize{12bp}{1.37\dimexpr 15.6pt}\selectfont}
  \fi%
}

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
  \chapter{摘要}
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
  \chapter{Abstract}
  \newcommand{\swufe@keywords@en}{#1}
}{%

  \nopagebreak
  \vspace{\baselineskip}
  \@@keywords{\swufe@keywords@en}
}

% 致谢
\newenvironment{acknowledgments}{%
  \chapter{致谢}
}{}

% 页码居中
\RequirePackage{fancyhdr}
\newcommand{\swufe@set@fancyhf}{%
  \fancyhf{} % 重置
  \fancyfoot[C]{\zihao{-5}\thepage}
  \ifswufe@degree@bachelor
    \renewcommand{\headrulewidth}{0pt}
  \else
    \fancyhead[CO]{\zihao{-5}\leftmark}
    \fancyhead[CE]{\zihao{-5}\rightmark}
    \renewcommand{\headrulewidth}{1pt}
  \fi
  \fancypagestyle{plain}{} % 使plain应用fancy的样式，每章的第一页会使用plain样式
  \pagestyle{fancy}
  \renewcommand\chaptermark[1]{%
    % 这里\CTEXifname表示标题不被编号时则不显示，见ctex宏包文档
    \markboth{\CTEXifname{\CTEXthechapter\quad}{}##1}{\CTEXifname{\CTEXthechapter\quad}{}##1}
  }
  \renewcommand\sectionmark[1]{%
    \markright{\CTEXthesection\quad ##1}
  }
}
\AtBeginDocument{%
  \swufe@set@fancyhf
}

% 封面
\RequirePackage{graphicx}
\renewcommand{\maketitle}{%
  \ifswufe@output@check\else%
    \cleardoublepage
    % 虽然规范上要求上下左右页边距为3cm，但实际给出的封面与申明页模板采用的Word默认页边距
    % 为达到一致的视觉效果，对封面页和申明页使用特别的页边距，并在其他页面重置
    \newgeometry{
      vmargin=2.54cm,
      hmargin=3.18cm,
    }
    \thispagestyle{empty} % 取消页码
    \ifswufe@degree@bachelor%
      \swufe@make@bachelor@cover%
    \else%
      \swufe@make@postgraduate@titlepage%
    \fi%
  \fi%
}

\newcommand{\swufe@make@bachelor@cover}{
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

% 研究生扉页
\newcommand{\swufe@make@postgraduate@titlepage}{%
  \begingroup
  \setlength{\parindent}{0pt}
  \setlength{\tabcolsep}{0pt}
  \CJKfamily{zhhei}
  \fontsize{16bp}{32pt}\selectfont
  \begin{tabular}{p{.5\textwidth}p{.5\textwidth}}
    分类号\CJKunderline{\hfill\swufe@clc\hfill} & 密级\CJKunderline{\hfill\swufe@secret@level\hfill} \\
    \multicolumn{2}{l}{U.D.C\hspace{6pt}\CJKunderline{\hfill\swufe@udc\hfill}}
  \end{tabular}

  \begin{center}
    \fontsize{18bp}{2\dimexpr 15.6pt}\selectfont
    \CJKfamily{hwzs}
    \ifswufe@degree@type@equivalent%
      \vspace{24pt}
      \textbf{具有研究生毕业同等学力人员申请硕士学位学位论文}
    \fi

    \vspace{52pt}
    \textbf{\swufe@title}

    \vspace{23pt}
    \fontsize{12bp}{15.6pt}\selectfont
    \textbf{\swufe@title@en}

    \vfill
    \def\swufe@@item##1:##2{%
    \makebox[5em][s]{##1} & \CJKunderline*{##2\hfill}\\
    }
    \ifswufe@degree@type@equivalent%
      \fontsize{15bp}{37pt}\selectfont
    \else%
      \fontsize{15bp}{35pt}\selectfont
    \fi%
    \CJKfamily+{zhhei}
    \def\swufe@@issue@date{%
      \swufe@date@format{\swufe@date}{\swufe@date@zh@digit}%
    }
    \begin{tabular}{c@{：}p{235pt}}
      \swufe@@item 学位申请人:\swufe@author
      \ifswufe@degree@type@equivalent\else%
        \swufe@@item 学\hfil 号:\swufe@student@id
      \fi%
      \swufe@@item 学\hfil 科\hfil 专\hfil 业:\swufe@discipline
      \swufe@@item 研\hfil 究\hfil 方\hfil 向:\swufe@author
      \swufe@@item 指\hfil 导\hfil 教\hfil 师:\swufe@supervisor
      \swufe@@item 定\hfil 稿\hfil 时\hfil 间:\swufe@@issue@date
    \end{tabular}
    \ifswufe@degree@type@equivalent%
      \vspace{140pt}
    \else%
      \vspace{220pt}
    \fi
  \end{center}
  \endgroup
}

% 版权申明
\newcommand{\statement}{
  \ifswufe@output@check\else%
    \cleardoublepage
    \thispagestyle{empty} % 取消页码
    \ifswufe@degree@bachelor%
      \swufe@make@bachelor@statement%
    \else%
      \swufe@make@postgraduate@statement%
    \fi%
    \restoregeometry
  \fi
}

\newcommand{\swufe@make@bachelor@statement}{
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
}

\RequirePackage{unicode-math}
\newcommand{\swufe@make@postgraduate@statement}{
  \vspace*{-18pt}
  \begin{center}
    \fontsize{18bp}{2\dimexpr 15.6pt}\selectfont
    \CJKfamily{zhsong}\bfseries
    西南财经大学学位论文原创性及知识产权声明
  \end{center}

  \vspace{2pt}
  \begingroup
  \CJKfamily+{zhfs}
  \bfseries
  \fontsize{16bp}{28pt}\selectfont
  本人郑重声明：所呈交的学位论文，是本人在导师的指
  导下独立进行研究工作所取得的成果。除文中已经注明引用
  的内容外，本论文不含任何其他个人或集体已经发表或撰写
  过的作品成果。对本文的研究做出重要贡献的个人和集体，
  均已在文中以明确方式标明，因本学位论文引起的法律结果
  完全由本人承担。

  \vspace{16pt}
  \fontsize{16bp}{25pt}\selectfont
  本人同意在校攻读学位期间论文工作的知识产权单位
  属西南财经大学。本人完全了解西南财经大学有关保留、使
  用学位论文的规定，即学校有权保留并向国家有关部门或机
  构送交论文的复印件和电子版，允许论文被查阅和借阅。本
  人授权西南财经大学可以将本学位论文的全部或部分内容
  编入有关数据库进行检索，可以采用影印、缩印、数字化或
  其他复制手段保存和汇编本学位论文。

  \vspace{14pt}
  \noindent 本学位论文属于

  % 勾选框
  \setlength{\fboxrule}{1.2pt}%
  \setlength{\fboxsep}{0pt}%
  \def\swufe@@checkbox{%
    \makebox[11pt][l]{% 最外层的盒子将勾选框包起来作为一个整体方便外部调整间距
      \makebox[0pt][l]{\framebox[13pt]{\parbox{0pt}{\vspace{10pt}}}}%
      $\checkmark$%
    }
  }
  \def\swufe@@emptybox{%
    \makebox[11pt][l]{%
      \framebox[13pt]{\parbox{0pt}{\vspace{10pt}}}%
    }
  }

  \def\swufe@@secret@year{%
    \underline{\raisebox{-1pt}{\makebox[41pt]{\hfil\swufe@secret@year\hfil}}}%
  }
  % 根据\swufe@secret@year是否为空来判断是否是公开的
  \newif\ifswufe@@secret@level@public
  \ifx\swufe@secret@year\@empty%
    \swufe@@secret@level@publictrue
  \fi%

  \vspace{14pt}
  \xeCJKsetup{ CJKecglue = {} } % 取消CJK与英文字符间距，这个影响是局部的
  \noindent 1、\ifswufe@@secret@level@public\swufe@@emptybox\else\swufe@@checkbox\fi
  保密，在\swufe@@secret@year 年解密后适用本授权书。

  \vspace{14pt}
  \noindent 2、\ifswufe@@secret@level@public\swufe@@checkbox\else\swufe@@emptybox\fi 不保密
  \xeCJKsetup{ CJKecglue = {~} } % 下面的日期之间还是需要间距

  \vspace{14pt}
  \noindent 特此声明。

  \begin{flushright}
    学位申请人：\hspace{4em}

    \vspace{14pt}
    \swufe@date@format{\swufe@date}{\swufe@date@zh@digit}
  \end{flushright}
  \endgroup
}

\RequirePackage{pdfpages}
\RequirePackage{filehook} % file hooks已可以由LaTeX core (2020/10/01)原生支持，这个宏包可提供兼容性
\AtEndDocument{%
  \ifswufe@output@check\else%
    \ifswufe@degree@bachelor%
      \cleardoublepage%
      \null\thispagestyle{empty}\newpage% 封底前面插入空白页保证封底在下
      \includepdf{backcover.pdf}%
    \fi
  \fi
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
  \ifswufe@system@mac%
    \IfFontExistsTF{Kaiti SC}{%
      \swufesetup{ cjk-font = mac }%
      \swufe@@font@settedtrue
    }{}%
  \fi
  \ifswufe@system@windows%
    \IfFontExistsTF{KaiTi}{%
      \swufesetup{ cjk-font = windows }%
    }{}%
  \fi
  \ifswufe@system@unix%
    \IfFontExistsTF{Noto Serif CJK SC}{%
      \IfFontExistsTF{Noto Sans CJK SC}{%
        \swufesetup{ cjk-font = noto }%
      }{}%
    }{}%
  \fi

  \ifswufe@cjk@font@auto%
    % 以上方案均未设置，采用fandol方案
    \swufesetup{ cjk-font = fandol }%
  \fi
}


% 一级标题中的华文中宋与封面的华文仿宋属于硬性规定，独立于前面的cjk-font设定
% 如果找不到相应的字体会fallback至前面cjk-font
\AtBeginDocument{%
  \IfFontExistsTF{STZhongsong}{%
    \setCJKfamilyfont{hwzs}{STZhongsong}%
  }{\swufe@hwzs@fallback}

  \IfFontExistsTF{STFangsong}{%
    \setCJKfamilyfont{hwfs}{STFangsong}%
  }{\swufe@hwfs@fallback}
}

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

% 一组默认值设置
\swufesetup{
  % 例如2020年9月（含）至2021年9月（不含）设定为2017届
  index = \swufe@date@format{\swufe@date}{\swufe@index@formatter},
  date = {\the\year-\swufe@twodigits\month-\swufe@twodigits\day},
  font = auto,
  cjk-font = auto,
  secret-year = {},
  secret-level = {},
  degree = bachelor,
  degree-type = academic,
}