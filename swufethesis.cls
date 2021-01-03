\NeedsTeXFormat{LaTeX2e}
\LoadClass{article}

% 正文小四号宋体
% 一级标题居中
\RequirePackage[zihao=-4,heading]{ctex}

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

% 标题
\RequirePackage{titlesec}
\titleformat*{\subsection}{\zihao{-3}\heiti} % 小三号黑体
\titleformat*{\subsubsection}{\zihao{-4}\heiti} % 小四号黑体

% 目录
\RequirePackage{tocloft}
\renewcommand{\cfttoctitlefont}{\vspace{3\baselineskip}\hfill\centering\bfseries\zihao{2}} % 段前3行，二号华文中宋加粗
\renewcommand{\cftaftertoctitle}{\hfill\vspace{2\baselineskip}} % 段后2行
\renewcommand{\cftsecfont}{\bfseries\zihao{-4}\songti}
\renewcommand{\cftsubsecfont}{\zihao{-4}\songti}

% 正文1.5倍行距
\renewcommand{\baselinestretch}{1.5}

% 表格五号字体 单倍行距
\let\oldtable\table
\let\oldendtable\endtable
\def\table[#1]{\oldtable[#1]\zihao{5}\renewcommand{\baselinestretch}{1}}
\def\endtable{\oldendtable}

% 关键词和摘要
\newcommand{\keywords}{\@ifstar\@@keywords\@keywords}
\newcommand{\@keywords}[1]{\noindent\textbf{关键词：#1}}
\newcommand{\@@keywords}[1]{\noindent\textbf{Keywords: #1}}
\renewenvironment{abstract}{%
    \newpage
    \setcounter{page}{1}
    \zihao{-4}
    {\centering\bfseries\zihao{2}摘要\par\vspace{1ex}} % 二号华文中宋
}{}
\newenvironment{abstract*}{%
    \newpage
    \setcounter{page}{1}
    \zihao{-4}
    {\centering\bfseries\zihao{2}Abstract\par\vspace{1ex}} % 二号Time New Roman
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
\renewcommand{\maketitle}{%
    \thispagestyle{empty} % 取消页码
    \def\thesistitle{总之这是一个很长很长很长很长很长很长的——《题目》}
    \def\adviser{XX老师}
    \def\school{哪一个学院}
    \def\major{这也是我财一个很长很长很长很长很长的专业名称（长到要加备注说明）}
    \def\stuid{4XXXXXXX}
    \def\name{某某某\textperiodcentered 某某}
    \noindent
    \includegraphics[scale=0.75]{logo-Swufe.png} % 貌似png图片不包含分辨率信息，需要手动指定 https://tex.stackexchange.com/questions/1625/how-to-make-images-appear-at-their-actual-size
    \vspace{46pt}
    \begin{center}
        {
            % 黑体小初加粗
            \zihao{-0}
            \heiti
            \bfseries
            2017届\break
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
                \entry 论文题目:\thesistitle{}
                \entry 学生姓名:\name{}
                \entry {所在学院}:\school{}
                \entry {专\hspace{2em}业}:\major{}
                \entry {学\hspace{2em}号}:\stuid{}
                \entry {指导教师}:\adviser{}
                \entry {成\hspace{2em}绩}:{}
            \end{tabular}
        }
        \vspace{\fill}

        {
            \def\twodigits##1{\ifnum##1<10 0\fi\the##1}
            \fangsong\bfseries\the\year 年\twodigits\month 月
        }
    \end{center}
}

% 版权申明
\newcommand{\statement}{
    \newpage
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

    \today
    \end{flushright}
}