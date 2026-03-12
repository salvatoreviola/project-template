#!/usr/bin/env bash
set -euo pipefail

FORCE=0
NO_DEPS=0

usage() {
  cat <<'USAGE'
Usage: ./main-setup.sh [--force] [--no-deps]

Options:
  --force    Overwrite existing files managed by this script.
  --no-deps  Skip venv setup, pip installs, and VS Code extension installs.
  -h, --help Show this help message.
USAGE
}

for arg in "$@"; do
  case "$arg" in
    --force)
      FORCE=1
      ;;
    --no-deps)
      NO_DEPS=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $arg"
      usage
      exit 1
      ;;
  esac
done

create_dir() {
  local dir="$1"
  mkdir -p "$dir"
  echo "Ensured directory: $dir"
}

write_file() {
  local path="$1"
  local mode="${2:-644}"

  if [[ -f "$path" && "$FORCE" -ne 1 ]]; then
    echo "Skipping existing file: $path"
    cat >/dev/null
    return 0
  fi

  cat >"$path"
  chmod "$mode" "$path"
  echo "Wrote file: $path"
}

echo "================================="
echo "Bootstrapping repository template"
echo "================================="

create_dir data/raw
create_dir data/clean
create_dir data/temp
create_dir data/lake/gold
create_dir data/lake/silver

create_dir output/figures
create_dir output/tables

create_dir paper/sections
create_dir paper/preamble
create_dir paper/bib

create_dir presentation/sections
create_dir presentation/preamble

create_dir sandbox
create_dir src
create_dir .vscode

write_file .gitignore <<'FILE'
# Python virtual environments
.venv/

# Environment variables
.env

# Jupyter notebook checkpoints
.ipynb_checkpoints/

# Data files
/data/raw/
/data/clean/
/data/temp/
/data/lake/

# Byte-compiled / optimized / DLL files
__pycache__/
*.py[codz]
*$py.class

# Readme.ipynb draft
README.ipynb

# LaTeX build
paper/build/
presentation/build/
FILE

write_file .env <<'FILE'
PYTHONPATH=.
API_KEY=your_api_key_here
FILE

write_file .env.example <<'FILE'
PYTHONPATH=.
API_KEY=replace_me
FILE

write_file config.py <<'FILE'
from pathlib import Path


def get_project_root() -> Path:
    current_path = Path(__file__).resolve()
    for parent in current_path.parents:
        if (parent / "src").is_dir() and (parent / "data").is_dir():
            return parent
    raise RuntimeError("Project root not found.")


MAIN_PATH = get_project_root()
DATA_PATH = MAIN_PATH / "data"
CODE_PATH = MAIN_PATH / "src"
OUTPUT_PATH = MAIN_PATH / "output"
FILE

write_file .vscode/settings.json <<'FILE'
{
  "latex-workshop.latex.outDir": "./build",
  "latex-workshop.latex.autoBuild.run": "onSave",
  "latex-workshop.view.pdf.viewer": "tab",
  "latex-workshop.latex.recipes": [
    {
      "name": "latexmk (Linux)",
      "tools": ["latexmk", "pdf linux"]
    },
    {
      "name": "latexmk (Windows)",
      "tools": ["latexmk", "pdf windows"]
    }
  ],
  "latex-workshop.latex.tools": [
    {
      "name": "latexmk",
      "command": "latexmk",
      "args": [
        "-pdf",
        "-interaction=nonstopmode",
        "-synctex=1",
        "-outdir=./build",
        "%DOC%"
      ]
    },
    {
      "name": "pdf windows",
      "command": "copy",
      "args": ["%OUTDIR_W32%\\%DOCFILE%.pdf", "%DIR_W32%\\"]
    },
    {
      "name": "pdf linux",
      "command": "cp",
      "args": ["%OUTDIR%/%DOCFILE%.pdf", "%DIR%/"]
    }
  ],
  "[latex]": {
    "editor.wordWrap": "on"
  },
  "python.envFile": "${workspaceFolder}/.env",
  "python.analysis.extraPaths": [
    "${workspaceFolder}",
    "${workspaceFolder}/src"
  ],
  "python.terminal.executeInFileDir": false
}
FILE

write_file .vscode/extensions.json <<'FILE'
{
  "recommendations": [
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-toolsai.jupyter",
    "james-yu.latex-workshop"
  ]
}
FILE

write_file README.md <<'FILE'
# Standard Academic Project Template in Economics

This repository provides a ready-made file system to develop an empirical project in economics with Python, LaTeX, and Beamer.

## Quick start

```bash
./main-setup.sh
```

Use `./main-setup.sh --force` to overwrite managed files.
FILE

write_file paper/main.tex <<'FILE'
\documentclass[12pt]{article}

\input{preamble/packages}
\input{preamble/macros}

\begin{document}

\input{sections/00-titlepage}

\section{Introduction}
\input{sections/01-introduction}

\newpage
\begin{refcontext}[sorting=nyt]
\printbibliography
\end{refcontext}

\end{document}
FILE

write_file paper/sections/00-titlepage.tex <<'FILE'
\title{Title}
\author[1]{Your Name\thanks{Corresponding author: you@example.com}}
\author[2]{Other Author}

\affil[1]{Affiliation A}
\affil[2]{Affiliation B}

\maketitle

\vspace{1cm}

\begin{abstract}
Your abstract here.

\vspace{1em}
\noindent\textbf{Keywords:} TODO

\vspace{1em}
\noindent\textbf{JEL Codes:} TODO
\end{abstract}

\newpage
FILE

write_file paper/sections/01-introduction.tex <<'FILE'
This is where your introduction would go.

And your citations \autocite{ritter2025economic}.
FILE

write_file paper/preamble/packages.tex <<'FILE'
\usepackage[T1]{fontenc}
\usepackage[american]{babel}
\usepackage{csquotes}
\usepackage{amsmath}

\usepackage[
    backend=biber,
    style=apa,
    maxcitenames=2,
    hyperref=true,
    sorting=ynt
]{biblatex}
\DeclareLanguageMapping{american}{english-apa}
\addbibresource{bib/bib.bib}

\usepackage{array}
\usepackage{booktabs}
\usepackage[margin=1in]{geometry}
\usepackage[para]{threeparttable}
\usepackage{authblk}
\renewcommand\Affilfont{\small}

\usepackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=blue,
    citecolor=blue,
    urlcolor=blue
}
FILE

write_file paper/preamble/macros.tex <<'FILE'
% Add custom LaTeX macros for the paper here.
FILE

write_file paper/bib/bib.bib <<'FILE'
@article{ritter2025economic,
  title={The economic effect of splitting a region in a centralized country: A case from Chile},
  author={Ritter, Sebastian},
  journal={Global Challenges \& Regional Science},
  volume={2},
  pages={100011},
  year={2025},
  publisher={Elsevier}
}
FILE

write_file presentation/main.tex <<'FILE'
\documentclass[aspectratio=129, xcolor=dvipsnames]{beamer}

\input{preamble/packages}
\input{preamble/macros}
\input{preamble/beamer_theme}

\title[Short Title]{Long Title}
\author[Your Short Name]{\textbf{Your Long Name}\inst{1}, Other Author\inst{2}}
\institute[]{\inst{1}Affiliation A \\ \inst{2}Affiliation B}
\subtitle[Short Event Title]{Full Event Title}
\date{\today}

\begin{document}

\begin{frame}
  \titlepage
\end{frame}

\section{Introduction}
\input{sections/00-intro}

\printbibliography

\clearpage
\appendix

\end{document}
FILE

write_file presentation/sections/00-intro.tex <<'FILE'
\begin{frame}

The best paper ever written \framecite{ritter2025economic}

\end{frame}
FILE

write_file presentation/preamble/packages.tex <<'FILE'
\usepackage[
    backend=biber,
    style=apa,
    maxcitenames=2,
    hyperref=true,
    sorting=ynt
]{biblatex}
\DeclareLanguageMapping{american}{english-apa}
\addbibresource{../paper/bib/bib.bib}

\usepackage[american]{babel}
\usepackage{csquotes}
\usepackage{amsmath}
\usepackage{graphicx}
\usepackage{subcaption}
\usepackage{appendixnumberbeamer}
\usepackage{booktabs}
\usepackage[para]{threeparttable}
FILE

write_file presentation/preamble/macros.tex <<'FILE'
\AtBeginSection{
\begin{frame}[noframenumbering,plain]{Outline}
\tableofcontents[currentsection]
\end{frame}}

\newcommand{\framecite}[1]{{\scriptsize\textcolor{gray}{\autocite{#1}}}}
FILE

write_file presentation/preamble/beamer_theme.tex <<'FILE'
\usetheme{Boadilla}
\usecolortheme[named=NavyBlue]{structure}
\setbeamertemplate{navigation symbols}{}
FILE

write_file sandbox/test.py <<'FILE'
# Check that everything is working
print("Seems like it's working...")
FILE

write_file src/stata-example.ipynb <<'FILE'
{
  "cells": [],
  "metadata": {
    "kernelspec": {
      "display_name": "Python 3",
      "language": "python",
      "name": "python3"
    },
    "language_info": {
      "name": "python"
    }
  },
  "nbformat": 4,
  "nbformat_minor": 5
}
FILE

write_file output/figures/.gitignore <<'FILE'
# Keep directory in git
*
!.gitignore
FILE

write_file output/tables/.gitignore <<'FILE'
# Keep directory in git
*
!.gitignore
FILE

if [[ "$NO_DEPS" -eq 0 ]]; then
  echo "================================="
  echo "Environment setup"
  echo "================================="

  if [[ ! -d ".venv" ]]; then
    echo "Creating virtual environment in .venv..."
    python3 -m venv .venv
  else
    echo ".venv already exists."
  fi

  # shellcheck disable=SC1091
  source .venv/bin/activate

  echo "Upgrading pip..."
  python -m pip install --upgrade pip

  if [[ -f requirements.txt ]]; then
    echo "Installing Python dependencies from requirements.txt..."
    pip install -r requirements.txt
  else
    echo "No requirements.txt found, skipping pip installs."
  fi

  EXTENSIONS=(
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-toolsai.jupyter"
    "james-yu.latex-workshop"
  )

  if command -v code >/dev/null 2>&1; then
    echo "Installing VS Code extensions..."
    for ext in "${EXTENSIONS[@]}"; do
      code --install-extension "$ext" --force
    done
  else
    echo "VS Code CLI 'code' not found; skipping extension install."
  fi
else
  echo "Skipped dependency/tool installation (--no-deps)."
fi

echo "================================="
echo "Template setup complete"
echo "Run source .venv/bin/activate to enter the environment."
echo "================================="
