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
It is distributed in binary format [@zenodo] because its implementation is written
as a ''Lepton'' file containing the full source code, manual and a tutorial.
The public repository is hosted on [Github](https://github.com/slithiaote/lepton).
Previous publications written using ''Lepton'' include [@LiThiaoTe20121723]
and [@LiThiaoTe2012439].

# References
