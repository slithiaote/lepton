(* 
Copyright Li-Thiao-Té Sébastien (2018)
lithiao@math.univ-paris13.fr
This file was generated from lepton.nw by lepton.bin

This software is a computer program whose purpose is to facilitate the
creation and distribution of literate executable papers. It processes
files containing source code and documentation, and can execute commands
to produce (scientific) reports.

This software is governed by the CeCILL  license under French law and
abiding by the rules of distribution of free software.  You can  use, 
modify and/ or redistribute the software under the terms of the CeCILL
license as circulated by CEA, CNRS and INRIA at the following URL
"http://www.cecill.info". 

As a counterpart to the access to the source code and  rights to copy,
modify and redistribute granted by the license, users are provided only
with a limited warranty  and the software's author,  the holder of the
economic rights,  and the successive licensors  have only  limited
liability. 

In this respect, the user's attention is drawn to the risks associated
with loading,  using,  modifying and/or developing or reproducing the
software by the user in light of its specific status of free software,
that may mean  that it is complicated to manipulate,  and  that  also
therefore means  that it is reserved for developers  and  experienced
professionals having in-depth computer knowledge. Users are therefore
encouraged to load and test the software's suitability as regards their
requirements in conditions enabling the security of their systems and/or 
data to be ensured and,  more generally, to use and operate it in the 
same conditions as regards security. 

The fact that you are presently reading this means that you have had
knowledge of the CeCILL license and that you accept its terms.
*)
print_endline "This is the Lepton/Lex implementation.";;
open Lepton;;       (* Load common definitions *)
open Interpreters;; (* Load the default set of interpreters *)
let option_spec = ("-o", Arg.String (fun s -> lepton_oc := open_out s), "name of the output file (default is stdout)") ::
                  ("-format_with", Arg.String Formatters.set, "set the formatter (default is LaTeX/minted") :: [] in
let anon_spec =   fun s -> lepton_ic := open_in s; in (* anonymous arguments are interpreted as input filename *)
Arg.parse option_spec anon_spec "usage: lepton [-format_with formatter] [filename] [-o output]";;
let chunks = Lexer.shabang (Lexing.from_channel !lepton_ic);;
let interpreter = function
  | Code (args, _) when args.(0) = "lepton_options" -> ignore(parse_chunklabel args); (* special chunk *)
  | Code (args, s) -> let option = parse_chunklabel args in
		      let plain, expanded = Lexer.expand "" "" (Lexing.from_string s) in
		      if option.write then send_to_file expanded args.(0);
		      let output = send_to_interpreter expanded option.interpreter in
		      if option.expand then !formatter args.(0) option [] expanded output
		      else !formatter args.(0) option (Lexer.chunkref_list (Lexing.from_string s)) plain output;
  | Doc s -> Lexer.lexpr (Lexing.from_string s);
in Queue.iter interpreter chunks;;
