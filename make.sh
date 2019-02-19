ocamllex lexer.mll 2>&1 # redirect stderr to stdout for inclusion in lepton.pdf
ocamlopt -o lepton.bin str.cmxa unix.cmxa lepton.ml lexer.ml interpreters.ml formatters.ml main.ml 2>&1
