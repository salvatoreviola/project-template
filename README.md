# Academic Project Template for Economics

A VS Code project template for empirical economics workflows, including data organization, Python and Stata scripts, LaTeX papers, Beamer presentations, and reproducible project paths.

## Status

This repository is experimental. The folder structure is usable for reference, but the setup scripts are not yet ready to run on a new machine.

## What’s Included

- Standard folders for `raw`, `clean`, `temp`, and `lake` data
- Separate `paper/` and `presentation/` LaTeX projects
- A `src/` directory for production code
- A `sandbox/` directory for quick tests and experiments
- VS Code settings for Python and LaTeX workflows
- Git ignore rules for artifacts, cache files, and data


## Dependencies

- Visual Studio Code (https://code.visualstudio.com/)
- Tex Live (https://www.tug.org/texlive/)
- Python (https://www.python.org/)
- Stata (https://www.stata.com/)
- Git (https://git-scm.com/)

## Useful Guides

- Latex in VS Code by Paul K. Wintz (https://paulwintz.com/latex-in-vscode/)


## Folders

### `.vscode/`

The `.vscode/` file contains the configuration for VS Code. In this example repository, the `settings.json` is mainly used to tell Latex (in this case Tex Live) how to compile latex files and where to store the output. As is, latex project in the `presentation/` and `paper/` folders are compiled whenever a `.tex` file from that folder is saved. The `build/` files from the compilation are stored in another folder called `build/` and can be ignored. `settings.json` also contains code which tells VS Code where to look for Python. 

Also in the `.vscode/` folder is an `extensions.json` file. There contains some of extensions which are necessary for working with Python and Latex in VS Code.

### `data/`

The `data/` folder contains a number of subfolders which reflect how I (currently) like to organize my data. `raw/` for all of the raw files, `lake/` for partitioned datasets that I want to query in SQL, `clean/` for final datasets, and `temp/` for anything in between. 

### `output/`

The `output/` folder like the `data/` folder, has some subfolders for storing results from estimations and graphical commands. I think its pretty self explanatory.

### `paper/`

The `paper/` folder is a self-contained, academic-style latex manuscript. There is a `bib/` folder for a `.bib` file, a `build/` folder where latex compilation artifacts go, `preamble/` and `sections/` folders as well as a `main.tex` and `main.pdf` file. the `preamble/` folder contains `.tex` files which can be used to set up the your latex environment for the paper. Examples are included. The `sections/` folder, contains `.tex` files for each of the parts of the paper. In this way, you can edit single sections of you document individually. Finally, the `main.tex` file sews all of the configuration and section files together and gets compiled into `main.pdf`.  The structure is flexible, but I think this approach helps to keep everything organized.

### `presentation/`

The `presentation/` folder is a self-contained, academic-style latex/beamer presentation. It is structure very similarly to the `paper/` folder. You can configure you settings in the various `.tex` files in the `preamble/` folder and structure sections in the `sections/` folder. One thing to note, is that the `presentation/` folder uses the same `.bib` file from the `paper/` folder.


### `sandbox/`

The `sandbox/` folder is a "sandbox". It's where you can test some code separately from you main, polished files. I don't really know if this is conventional, but I have come across it in other projects and it helps to isolate and maintain working scripts in a safe place. For now, it only contains a `test.py` file which ensures that folder and file paths can be correctly imported and that python is working.


### `src/`

`src/` is short for source. In conventional programming (not really the same as the scripting that PhDs in economics do), this is the standard name for the "final" code directory. This folder is meant to contain all of the code/scripts that are working correctly and you would ultimately include in a replication package. It contains a `stata-example.ipynb` jupyter notebook file which gives instruction on how to execute Stata code from Python.


### `config.py`

`config.py` is a file which I use to set the paths for my entire project. It is short and simple. All it does is define the paths to the folders that I will need to access when working with data and storing outputs. It should automatically point to the folders in this repository without any additional setup. 


### `.env.example`

`.env.example` is a (not entirely necessary) file which should contain "environment" variables. In you own project, it should just be called `.env`. It is supposed to contain variables which you need to access but do not want to include explicitly in another file that someone else might see. For example, you often need a personal API key when gather data from an external source. Rather than keeping this key in the file where you call the API, you can keep it here an load it in the necessary file using built-in tools like Pythons `dotenv()` module. This is assuming that you are tracking you code with git and maintaining it in a public github repository. If you are not doing this, then you likely don't need this file.


### `.gitignore`

`.gitignore` is another sort of configuration file used with git. If you are have initiallized git in you project folder, all of the changes you make will be "tracked". In VS Code, you can tell when you have created a new file or made changes to one based on the color of the file name and the letter which appears next to it. The `.gitignore` file tells git which files not to track. As a result, these files will not be backed up to github. In this example, artifact (e.g., `build/`) and cache (e.g., `__pylance__`) files and folders are ignored as well as most of the `data/` folder. The `data/` folder will almost certainly be the largest part of your project and will likely exhaust the amount of free storage that github gives you (it's not designed for large files and there's usually no reason to track changes in data files). Notice that in the example, there `.env` and `.venv` files are also ignored. The `.env.example` section explained why in the case of `.env` files. As for `.venv`, this may or may not apply to you, but either way, there's no reason to back it up.


### `main-setup.sh` and `setup.sh`

These two files are experimental bash scripts whose ultimate goal is to be used to create an (this) entire repository/project folder from a single, automated script. That is, every file and line of text will be automatically written as a result of running the `main-setup.sh`. While the one of the goals of this repository is to give an overview of an economics project in VS Code using multiple different coding languages and statistical software, I started working on it to have an easy way of beginning a new project. Now, given the integration of LLMs like Codex and Claude Code into VS Code, and the fact that every one is using them, it seems important that every PhD (in economics at least) have some idea of how to maintain projects in VS Code. 

