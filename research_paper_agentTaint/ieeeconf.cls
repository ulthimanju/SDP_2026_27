\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ieeeconf}[2026/11/02 Unified IEEE conference class V1.1]

% This paper template is maintained by the IEEE Signal Processing Society. 
%
% Policy 7.6.6: Conference and Workshop Paper Template. 
% All sole-sponsored conferences, workshops, and technical meetings shall 
% exclusively use the IEEE Signal Processing Society (SPS) Paper Template.
%
% Exceptions may be granted on a case-by-case basis by the VP of Conferences, 
% allowing only for minimal adjustments to accommodate specific meeting 
% instructions. The Conferences Board will oversee ongoing maintenance of 
% this template. 
%
% Original template design and implementation: Jonathan Le Roux (MERL)
%
% To report any template issues or questions, please contact: 
% sp.conferences.info@ieee.org
%
% --------------------------------------------------------------------------
% ieeeconf.cls
%
% A thin conference wrapper around the official IEEEtran class.
% The class fixes the underlying layout to conference mode, exposes a small
% workflow-oriented option surface, and provides a compact structured
% author/affiliation interface.
%
% Public class options:
%   singleanonymous   author info shown, line numbers on, hyperlinks on
%   review            alias for singleanonymous
%   doubleanonymous   author info hidden, line numbers on, hyperlinks on
%   doubleblind       alias for doubleanonymous
%   cameraready       author info shown, line numbers off, hyperlinks on
%   final             alias for cameraready
%   nohyperlinks      Disable hyperlinks in the generated PDF. Use only
%                     if hyperlinks cause compatibility or submission issues.
%   9pt, 10pt         choose the base font size
%
% Core public commands:
%   \title{...}
%   \thanks{...}                    % optional unnumbered first-column footnote
%   \firstcolumnfootnote{...}       % explicit form of the same footnote
%   \addauthor{Author Name}{1,2}
%   \addauthorbreak{Author Name}{3}    % forced line break before this author
%   \authorbreak                       % forced line break after current author
%   \addaffiliation{1}{Affiliation text}
%   \addaffiliation{1}{*}{Affiliation text}   % optional custom marker
%   \addaffiliationbreak{2}{Affiliation text}
%   \affiliationbreak                  % forced line break before next affiliation
%   \addemail{1}{email@example.com}    % optional; displayed with affiliation 1
%
% Notes:
% - Section-title capitalization is preserved exactly as authored.
% - The class intentionally hides most IEEEtran options from authors.
% --------------------------------------------------------------------------

% --------------------------------------------------------------------------
% Mode and size options
% --------------------------------------------------------------------------
\newif\ifieeeconf@singleanonymous
\newif\ifieeeconf@doubleanonymous
\newif\ifieeeconf@cameraready
\newif\ifieeeconf@hyperlinks
\newif\ifieeeconf@pdfmetadata
\newif\ifieeeconf@linenumbers
\newif\ifieeeconf@showacks

% Font size
\def\ieeeconf@fontsize{10pt}

\DeclareOption{9pt}{\def\ieeeconf@fontsize{9pt}}
\DeclareOption{10pt}{\def\ieeeconf@fontsize{10pt}}

% Mode
\ieeeconf@camerareadytrue

\def\ieeeconf@setmode@singleanonymous{%
  \ieeeconf@singleanonymoustrue
  \ieeeconf@doubleanonymousfalse
  \ieeeconf@camerareadyfalse
}
\def\ieeeconf@setmode@doubleanonymous{%
  \ieeeconf@singleanonymousfalse
  \ieeeconf@doubleanonymoustrue
  \ieeeconf@camerareadyfalse
}
\def\ieeeconf@setmode@cameraready{%
  \ieeeconf@singleanonymousfalse
  \ieeeconf@doubleanonymousfalse
  \ieeeconf@camerareadytrue
}

\DeclareOption{singleanonymous}{\ieeeconf@setmode@singleanonymous}
\DeclareOption{singleblind}{%
  \ClassWarningNoLine{ieeeconf}{Option `singleblind' is deprecated; use `singleanonymous' instead}%
  \ieeeconf@setmode@singleanonymous
}
\DeclareOption{review}{\ieeeconf@setmode@singleanonymous}

\DeclareOption{doubleanonymous}{\ieeeconf@setmode@doubleanonymous}
\DeclareOption{doubleblind}{%
  \ClassWarningNoLine{ieeeconf}{Option `doubleblind' is deprecated; use `doubleanonymous' instead}%
  \ieeeconf@setmode@doubleanonymous
}

\DeclareOption{cameraready}{\ieeeconf@setmode@cameraready}
\DeclareOption{final}{\ieeeconf@setmode@cameraready}

% Use hyperlinks by default and only disable if `nohyperlinks' is passed as option
\ieeeconf@hyperlinkstrue

\DeclareOption{nohyperlinks}{%
  \ieeeconf@hyperlinksfalse
}

\DeclareOption*{\ClassWarning{ieeeconf}{Unknown option `\CurrentOption' ignored}}
\ProcessOptions\relax

% Derived policy flags
\ifieeeconf@singleanonymous
  \ieeeconf@pdfmetadatatrue
  \ieeeconf@linenumberstrue
  \ieeeconf@showackstrue
\else\ifieeeconf@doubleanonymous
  \ieeeconf@pdfmetadatafalse
  \ieeeconf@linenumberstrue
  \ieeeconf@showacksfalse
\else
  \ieeeconf@pdfmetadatatrue
  \ieeeconf@linenumbersfalse
  \ieeeconf@showackstrue
\fi\fi

\def\ieeeconf@modename{camera-ready}
\ifieeeconf@singleanonymous
  \gdef\ieeeconf@modename{single-anonymous review}
\else\ifieeeconf@doubleanonymous
  \gdef\ieeeconf@modename{double-anonymous review}
\fi\fi

% --------------------------------------------------------------------------
% Underlying engine
% --------------------------------------------------------------------------
\expandafter\LoadClass\expandafter[\ieeeconf@fontsize,conference,letterpaper,oneside]{IEEEtran}
\ClassInfo{ieeeconf}{Using \ieeeconf@modename\space mode with \ieeeconf@fontsize}

% --------------------------------------------------------------------------
% Required packages
% --------------------------------------------------------------------------
\RequirePackage{etoolbox}
\RequirePackage{array}
\RequirePackage{amsmath,amssymb}
\RequirePackage{graphicx}
\RequirePackage{cite}
\RequirePackage{comment}

% Let hyperref load url to avoid \showhyphens warnings.
\PassOptionsToPackage{hyphens}{url}
\RequirePackage{xcolor}

% Hyperlink policy.
\ifieeeconf@hyperlinks
  \RequirePackage[colorlinks=true,allcolors=.,bookmarks=false]{hyperref}
\else
  \RequirePackage[draft,bookmarks=false,hidelinks]{hyperref}
\fi

% Commands that should be ignored or rewritten when converted to PDF strings.
\pdfstringdefDisableCommands{%
  \def\thanks#1{}%
}

% PDF metadata policy.
\AtBeginDocument{%
  \ifieeeconf@doubleanonymous
    \gdef\ieeeconf@pdfauthor{Author names withheld for review}%
  \fi
  \global\let\@author\ieeeconf@pdfauthor
  \hypersetup{
      pdftitle={\@title},
      pdfauthor={\@author},
      pdfsubject={},
      pdfkeywords={}
    }%
}


% Line-number policy.
% \ifieeeconf@linenumbers
\RequirePackage[switch]{lineno}
% \fi

% --------------------------------------------------------------------------
% Geometry / sectioning tweaks for short conference papers.
% Keep author-provided capitalization exactly as given.
% --------------------------------------------------------------------------
\renewcommand{\thesectiondis}{\arabic{section}.}
\renewcommand{\thesubsectiondis}{\thesectiondis\arabic{subsection}.}
\renewcommand{\thesubsubsectiondis}{\thesubsectiondis\arabic{subsubsection}.}
\renewcommand{\thesection}{\arabic{section}}
\renewcommand{\thesubsection}{\thesectiondis\arabic{subsection}}
\renewcommand{\thesubsubsection}{\thesubsectiondis\arabic{subsubsection}}
\renewcommand{\appendixname}{Appendix}
\renewcommand{\appendix}{%
  \par
  \setcounter{section}{0}%
  \renewcommand{\thesection}{\Alph{section}}%
  \renewcommand{\thesectiondis}{\Alph{section}.}%
  \renewcommand{\theHsection}{Appendix.\Alph{section}}%
  \bgroup
    \par\addvspace{2ex plus 1ex minus 0.5ex}%
    \centering
    {\normalfont\Large\bfseries\appendixname\par}%
    \vspace{0.7ex plus 1ex minus 0ex}%
  \egroup
  \@IEEEgobbleleadPARNLSP
}

% Abstract heading styled like section title, but unnumbered and centered.
\def\abstract{%
  \normalfont
  \bgroup
    \par\addvspace{0pt}%
    \centering
    {\normalfont\Large\bfseries\abstractname\par}%
    \vspace{0.7ex plus 1ex minus 0ex}%
  \egroup
  \@IEEEgobbleleadPARNLSP
}
\def\endabstract{%
  \par
  \normalfont\normalsize
}
\def\section{\@startsection{section}{1}{\z@}%
{-1.5ex plus -1.5ex minus -0.5ex}%
{0.7ex plus 1ex minus 0ex}%
{\normalfont\Large\bfseries}}
\def\subsection{\@startsection{subsection}{2}{\z@}%
{-1.25ex plus -1.25ex minus -0.5ex}%
{0.7ex plus .5ex minus 0ex}%
{\normalfont\normalsize\bfseries}}

\def\subsubsection{\@startsection{subsubsection}{3}{\parindent}%
  {0ex plus 0.1ex minus 0.1ex}%
  {0ex}%
  {\normalfont\normalsize\itshape}}

% Allow more shrinking after floats.
% Single-column floats.
\floatsep 0.55\baselineskip plus 0.2\baselineskip minus 0.2\baselineskip
\textfloatsep 0.85\baselineskip plus 0.2\baselineskip minus 0.3\baselineskip
% Double-column floats (full width).
\dblfloatsep 0.65\baselineskip plus 0.2\baselineskip minus 0.2\baselineskip
\dbltextfloatsep 0.95\baselineskip plus 0.2\baselineskip minus 0.3\baselineskip

% --------------------------------------------------------------------------
% Caption/table formatting tweaks
% --------------------------------------------------------------------------
% Tweak space between table caption and table.
\renewcommand{\@IEEEtablecaptionsepspace}{\vskip-2pt\relax}

% Use Arabic table numbers and "Table" label.
\renewcommand{\thetable}{\arabic{table}}
\renewcommand{\tablename}{Table}

% Space between figure content and caption.
\renewcommand{\@IEEEfigurecaptionsepspace}{\vskip0.5\baselineskip\relax}

% Caption style:
% - Table treated like figure (label inline with caption text)
% - Bold label + colon + single nonbreaking space
\long\def\@makecaption#1#2{%
% test if this is for a table
\ifx\@captype\@IEEEtablestring%
\footnotesize\bgroup\par\@IEEEtabletopskipstrut{\normalfont\footnotesize \textbf{#1}}: {\normalfont\footnotesize #2}\par\addvspace{0.5\baselineskip}\egroup%
\@IEEEtablecaptionsepspace
% if not a table, format as a figure
\else
\@IEEEfigurecaptionsepspace
\setbox\@tempboxa\hbox{\normalfont\footnotesize \textbf{#1}:\nobreakspace #2}%
\ifdim \wd\@tempboxa >\hsize%
\setbox\@tempboxa\hbox{\normalfont\footnotesize \textbf{#1}:\nobreakspace}%
\parbox[t]{\hsize}{\normalfont\footnotesize\noindent\unhbox\@tempboxa#2}%
\else%
\hbox to\hsize{\normalfont\footnotesize\hfil\box\@tempboxa\hfil}%
\fi\fi}

% --------------------------------------------------------------------------
% Metadata storage
% --------------------------------------------------------------------------
\newcounter{ieeeconf@authorcount}
\newcounter{ieeeconf@affcount}

\def\ieeeconf@afforder{}
\def\ieeeconf@pendingauthorbreak{0}
\def\ieeeconf@pendingaffbreak{0}
\def\ieeeconf@firstcolumnfootnotes{}
\def\ieeeconf@pdfauthor{}

\newcommand{\ieeeconf@storefirstcolumnfootnote}[1]{%
  \g@addto@macro\ieeeconf@firstcolumnfootnotes{\ieeeconf@printfirstcolumnfootnote{#1}}%
}
\renewcommand{\thanks}[1]{\ieeeconf@storefirstcolumnfootnote{#1}}
\newcommand{\firstcolumnfootnote}[1]{\ieeeconf@storefirstcolumnfootnote{#1}}

% Optional emails per affiliation id.
\newcommand{\addemail}[2]{%
  \expandafter\gdef\csname ieeeconf@email@#1\endcsname{#2}%
}

% Affiliation text stored by id. Order is the declaration order.
% Backward-compatible forms:
%   \addaffiliation{id}{text}
%   \addaffiliation{id}{marker}{text}
\newcommand{\ieeeconf@addaffiliationcore}[3]{%
  \@ifundefined{ieeeconf@affiliation@#1}{%
    \stepcounter{ieeeconf@affcount}%
    \ifnum\value{ieeeconf@affcount}=1\relax
      \xdef\ieeeconf@afforder{#1}%
    \else
      \xdef\ieeeconf@afforder{\ieeeconf@afforder,#1}%
    \fi
    \edef\ieeeconf@tmpaffbreakbefore{\ieeeconf@pendingaffbreak}%
    \expandafter\xdef\csname ieeeconf@affbreakbefore@#1\endcsname{\ieeeconf@tmpaffbreakbefore}%
  }{%
    \ClassWarning{ieeeconf}{Affiliation id `#1' redefined}%
  }%
  \expandafter\gdef\csname ieeeconf@affiliationmark@#1\endcsname{#2}%
  \expandafter\gdef\csname ieeeconf@affiliation@#1\endcsname{#3}%
  \gdef\ieeeconf@pendingaffbreak{0}%
}
\newcommand{\ieeeconf@addaffiliationnomarker}[2]{\ieeeconf@addaffiliationcore{#1}{#1}{#2}}
\newcommand{\ieeeconf@addaffiliationwithmarker}[3]{\ieeeconf@addaffiliationcore{#1}{#2}{#3}}
\newcommand{\addaffiliation}[2]{%
  \@ifnextchar\bgroup
    {\ieeeconf@addaffiliationwithmarker{#1}{#2}}%
    {\ieeeconf@addaffiliationnomarker{#1}{#2}}%
}
\newcommand{\affiliationbreak}{\gdef\ieeeconf@pendingaffbreak{1}}
\newcommand{\addaffiliationbreak}[2]{%
  \affiliationbreak
  \@ifnextchar\bgroup
    {\ieeeconf@addaffiliationwithmarker{#1}{#2}}%
    {\ieeeconf@addaffiliationnomarker{#1}{#2}}%
}

\newcommand{\ieeeconf@getaffiliationmarker}[1]{%
  \@ifundefined{ieeeconf@affiliationmark@#1}{#1}{\csname ieeeconf@affiliationmark@#1\endcsname}%
}

\newcommand{\ieeeconf@printaffmarkers}[1]{%
  \def\ieeeconf@firstaffmarker{1}%
  \def\ieeeconf@tmpmarkers{}%
  \@for\ieeeconf@tmpaffid:=#1\do{%
    \edef\ieeeconf@tmpaffmarker{\ieeeconf@getaffiliationmarker{\ieeeconf@tmpaffid}}%
    \ifstrempty{\ieeeconf@tmpaffmarker}{}{%
      \ifnum\ieeeconf@firstaffmarker=1\relax
        \gdef\ieeeconf@firstaffmarker{0}%
      \else
        \gappto\ieeeconf@tmpmarkers{,}%
      \fi
      \expandafter\gappto\expandafter\ieeeconf@tmpmarkers\expandafter{\ieeeconf@tmpaffmarker}%
    }%
  }%
  \ifstrempty{\ieeeconf@tmpmarkers}{}{\textsuperscript{\ieeeconf@tmpmarkers}}%
}

% Internal helper for author storage.
\newcommand{\ieeeconf@storeauthor}[3]{%
  \stepcounter{ieeeconf@authorcount}%
  \edef\ieeeconf@tmpauthorbreakbefore{\ieeeconf@pendingauthorbreak}%
  \ifnum#1=1\relax
    \def\ieeeconf@tmpauthorbreakbefore{1}%
  \fi
  \expandafter\gdef\csname ieeeconf@authorname@\arabic{ieeeconf@authorcount}\endcsname{#2}%
  \expandafter\gdef\csname ieeeconf@authoraffs@\arabic{ieeeconf@authorcount}\endcsname{#3}%
  \expandafter\xdef\csname ieeeconf@authorbreakbefore@\arabic{ieeeconf@authorcount}\endcsname{\ieeeconf@tmpauthorbreakbefore}%

  % Append a sanitized author name to the PDF author list.
  \begingroup
  \def\thanks##1{}%
  \ifnum\value{ieeeconf@authorcount}=1\relax
    \protected@xdef\ieeeconf@pdfauthor{#2}%
  \else
    \protected@xdef\ieeeconf@pdfauthor{%
      \ieeeconf@pdfauthor, #2%
    }%
  \fi
  \endgroup
  
  \gdef\ieeeconf@pendingauthorbreak{0}%
}

\newcommand{\addauthor}[2]{\ieeeconf@storeauthor{0}{#1}{#2}}
\newcommand{\addauthorbreak}[2]{\ieeeconf@storeauthor{1}{#1}{#2}}
\newcommand{\authorbreak}{\gdef\ieeeconf@pendingauthorbreak{1}}

% --------------------------------------------------------------------------
% Rendering helpers
% --------------------------------------------------------------------------
\newcommand{\ieeeconf@printauthors}{%
  \begingroup
  \centering
  \normalfont\large\itshape
  \ifnum\value{ieeeconf@authorcount}>0\relax
    \count@=1\relax
    \loop
      \ifnum\count@>1
        \ifnum\csname ieeeconf@authorbreakbefore@\number\count@\endcsname=1\relax
          \\
        \else
          ,\ \nobreak
        \fi
      \fi
      \csname ieeeconf@authorname@\number\count@\endcsname%
      \expandafter\ieeeconf@printaffmarkers\expandafter{\csname ieeeconf@authoraffs@\number\count@\endcsname}%
      \advance\count@ by 1\relax
      \ifnum\count@<\numexpr\value{ieeeconf@authorcount}+1\relax
    \repeat
  \fi
  \par
  \endgroup
}

\newif\ifieeeconf@firstaffiliation
\newcommand{\ieeeconf@printoneaffiliation}[1]{%
  \ifnum\csname ieeeconf@affbreakbefore@#1\endcsname=1\relax
    \ifieeeconf@firstaffiliation
    \else
      \\
    \fi
  \else
    \ifieeeconf@firstaffiliation
    \else
      \quad
    \fi
  \fi
  \ieeeconf@firstaffiliationfalse
  \edef\ieeeconf@tmpaffmarker{\ieeeconf@getaffiliationmarker{#1}}%
  \ifstrempty{\ieeeconf@tmpaffmarker}{}{\textsuperscript{\ieeeconf@tmpaffmarker}}%
  \csname ieeeconf@affiliation@#1\endcsname%
  \@ifundefined{ieeeconf@email@#1}{}{\ \texttt{\csname ieeeconf@email@#1\endcsname}}%
}
\newcommand{\ieeeconf@printaffiliations}{%
  \begingroup
  \centering
  \normalfont\large
  \ieeeconf@firstaffiliationtrue
  \@for\ieeeconf@affid:=\ieeeconf@afforder\do{%
    \expandafter\ieeeconf@printoneaffiliation\expandafter{\ieeeconf@affid}%
  }%
  \par
  \endgroup
}

\newcommand{\ieeeconf@printfirstcolumnfootnote}[1]{%
  \insert\footins{%
    \reset@font\footnotesize
    \interlinepenalty\interfootnotelinepenalty
    \splittopskip\footnotesep
    \splitmaxdepth \dp\strutbox
    \floatingpenalty \@MM
    \hsize\columnwidth
    \@parboxrestore
    \color@begingroup
      \noindent #1\par
    \color@endgroup
  }%
}

\newcommand{\ieeeconf@printanonymousauthors}{%
  \begingroup
  \centering
  {\normalfont\large\itshape Anonymous submission\par}
  \vskip 1.0\baselineskip
  {\normalfont\large Author names and affiliations withheld for review\par}
  \endgroup
}

\newcommand{\ieeeconf@printtitleblock}{%
  \ifieeeconf@doubleanonymous
    \ieeeconf@printanonymousauthors
  \else
    \ieeeconf@printauthors
    \vskip 1.0\baselineskip
    \ieeeconf@printaffiliations
  \fi
}

% --------------------------------------------------------------------------
% Title block
% --------------------------------------------------------------------------
\renewcommand{\maketitle}{%
  \par
  \begingroup
    \def\thefootnote{}%
    \def\@makefnmark{\hbox{$^{\@thefnmark}$\hss}}%
    \if@twocolumn
      \twocolumn[\ieeeconf@@maketitle]%
    \else
      \newpage
      \global\@topnum\z@
      \ieeeconf@@maketitle
    \fi
    \@thanks
  \endgroup
  \ieeeconf@firstcolumnfootnotes
  \setcounter{footnote}{0}%
  \let\maketitle\relax
  \let\ieeeconf@@maketitle\relax
  \gdef\thefootnote{\arabic{footnote}}%
  \gdef\@thanks{}%
  \ifieeeconf@linenumbers
    \linenumbers
  \fi
}

\newcommand{\ieeeconf@@maketitle}{%
  \newpage
  \vskip 1.0\baselineskip
  \centering
  {\huge \@title\par}
  \vskip 1.0\baselineskip
  \ieeeconf@printtitleblock
  \vskip 1.5em
}

% --------------------------------------------------------------------------
% Acknowledgments environment
% --------------------------------------------------------------------------
\ifieeeconf@showacks
  \newenvironment{acknowledgments}{\section*{Acknowledgments}}{}
\else
  \excludecomment{acknowledgments}
\fi

\endinput
