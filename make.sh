ocamllex lexer.mll
ocamlopt -o lepton.bin str.cmxa unix.cmxa lepton.ml lexer.ml interpreters.ml formatters.ml main.ml
