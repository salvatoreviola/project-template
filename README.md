# Standard Academic Project Template in Economics

This repository provides a ready-made file system within VS Code to develop an empirical project within economics. The intention of this repository is stardize my personal workflow within VS Code to streamline the initiation of future project. The repository supplies a project structure which includes separate spaces for data, empirical analysis, test spaces, Latex-based document editing, Beamer-style presentation creation, reproducible workflows (src), Stata script execution and utility. With the '''setup.sh''' script, this repo should intiailize a workspace in VS Code which allows users to conduct a single project, start to finish, within a single, integrated coding environment (IDE) that is compataible with common academic/economic workflows as well as git-trackable.  

## File Stystem 
'''

├── config.py
├── data
│   ├── lake
│   │   ├── gold
│   │   └── silver
│   └── raw
├── output
│   ├── figures
│   └── tables
├── paper
│   ├── bib
│   │   └── bib.bib
│   ├── main.pdf
│   ├── main.tex
│   ├── preamble
│   │   ├── macros.tex
│   │   └── packages.tex
│   └── sections
│       ├── 00-titlepage.tex
│       └── 01-introduction.tex
├── presentation
│   ├── main.pdf
│   ├── main.tex
│   ├── preamble
│   │   ├── beamer_theme.tex
│   │   ├── macros.tex
│   │   └── packages.tex
│   └── sections
│       └── 00-intro.tex
├── README.md
├── sandbox
│   └── test.py
├── setup.sh
└── src
    └── stata-example.ipynb

'''
