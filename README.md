---
title: 'Lepton: An automaton for Literate Executable Papers'
tags:
  - Ocaml
  - literate programming
  - reproducible research
authors:
  - name: Sébastien Li-Thiao-Té
    orcid: 0000-0002-4977-4969
    affiliation: "1" 
affiliations:
 - name: Université Paris 13, Sorbonne Paris Cité, LAGA, CNRS UMR 7539
   index: 1
date: 12 July 2018
bibliography: biblio_lepton.bib
---

# Summary

Source code is very hard to maintain when the documentation is missing. Recognizing
this fact, D. Knuth [@Knuth84literateprogramming] proposed the literate programming
paradigm, i.e. that source code and documentation should be written at the
same time, inside the same file, and in a format designed for human understanding.

''Lepton'' adds documents such as data analysis reports and scientific papers to this
vision. To enable reproducible research, ''Lepton'' makes it easy to include scripts
or complete programs, compilation and execution instructions, as well as execution
results in the same file. Offloading execution to ''Lepton'' makes the analysis
operator-independent and easy to reproduce. In the spirit of literate programming,
the plain text file format used by ''Lepton'' is intended to be human-understandable
as opposed to machine-readable, and simple enough to be usable without the software.

''Lepton'' consists in a standalone executable that processes plain text files
written in a documentation format such as HTML or LaTeX with optional blocks that
can contain files to be written to disk, source code or executable instructions.
It is distributed as a ''Lepton'' file containing the full source code, manual and a tutorial.
The package contains an extracted copy of the source code that can be compiled without ''Lepton''.

# Documentation
- `lepton_manual.pdf` contains usage instructions
- `lepton.pdf` contains the implementation details.

# Installation
The root directory contains all the necessary files for using Lepton:
- The `lepton.bin` executable can be compiled with the included `make.sh` script.
- The `lepton.sty` file is useful for producing files in LaTeX together with code highlighting with the Pygments library.
  The `lepton.bib` file contains references in BibTeX format.

Requirements
- [OCaml](https://ocaml.org/docs/install.html) > 4.0

# Examples
Three examples are provided :
- `hello.nw` is a minimal working example showing how to embed OCaml source code and execute it. It requires only LaTeX and OCaml. See Section 1 of `lepton_manual.pdf` for details.
- `fibonacci.nw` is an example of a scientific report comparing several implementations of the Fibonacci sequence and their running times. The corresponding rendered PDF `fibonacci.pdf` contains instructions on how to execute it. It has the same requirements as "Boostrapping".
- `lepton.nw` is the source file used for the source code and the documentation of Lepton. Executing this example will regenerate both the binary executable and the PDF documentation. The process is described in the "Bootstrapping" section of this document and in `lepton.pdf`.

# Bootstrapping
All the provide files can be re-generated from the file `lepton.nw` in the `bootstrap` directory. 
This will produce a new executable, extract copies of the source files. 
Continuous Integration is defined in `.gitlab-ci.yml` and run on [](https://plmlab.math.cnrs.fr/lithiaote/lepton)

Requirements
- [LaTeX](https://www.latex-project.org/get/)
- [Pygments](http://pygments.org/download/) for syntax highlighting and the `minted` [LaTeX package](https://ctan.org/pkg/minted?lang=en)

Steps :
- rename the executable, e.g. `mv lepton.bin lepton`.  (the next command will run `make.sh` and attempt to overwrite `lepton.bin`)
- process the main source file with Lepton `./lepton lepton.nw -o lepton.tex`
- (optional) compile the re-generated documentation with LaTeX

```
xelatex -shell-escape -8bit lepton.tex
bibtex lepton.aux
xelatex -shell-escape -8bit lepton.tex
xelatex -shell-escape -8bit lepton.tex # LaTeX needs to execute twice to resolve references
```

# Contributing
If you wish to report bugs, please use the issue tracker at Github. If you would like to contribute to Lepton, just open an issue or a merge request.
