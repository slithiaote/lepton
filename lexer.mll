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
{ open Hashtbl;;  open Buffer;; open Lepton;;
  let accu = Queue.create ();; let buffer = create 100;;
}
let char = [^ '\n']
let blank = [' ' '\t']
let chunk_start = "<<" (char* as h) ">>=" char* "\n"? as s
let linput = "\\Li" "nput{" (char* as file) "}" char* "\n"? as s
let lexp = "\\L" "expr{" ([^ '}' '\n']* as process) "}{" ([^ '}' '\n']* as code) "}"
let chunk_ref = (blank* as b) "<<" (char* as h) ">>" char* "\n"? as s
rule shabang = parse    | ("#!" char* "\n")? { lexer lexbuf; Queue.add (Doc (contents buffer)) accu; accu}
and lexer = parse
    | chunk_start { Queue.add (Doc (contents buffer)) accu; clear buffer;
		    let a = split_header h in ignore(gobble 1 lexbuf); add_buffer (get_chunk a.(0)) buffer; 
		    Queue.add (Code (a,contents buffer)) accu; clear buffer; lexer lexbuf }
    | linput { lexer (Lexing.from_channel (open_in file)); lexer lexbuf }
    | char* "\n"? as s { add_string buffer s; lexer lexbuf } | eof {}
and gobble level = parse
    | chunk_start            { add_string buffer s; gobble (level+1) lexbuf }
    | "@@" char* "\n"?  as s { add_string buffer s; gobble level lexbuf }
    | "@"  char* "\n"?  as s { if (level > 1) then (add_string buffer s; gobble (level-1) lexbuf) else s;}
    |      char* "\n"?  as s { add_string buffer s; gobble level lexbuf }
    | eof                    { failwith "Lexing : eof not permitted in gobble mode";}
and lexpr = parse
    | lexp { output_string !lepton_oc (send_to_interpreter (code^"\n") process); lexpr lexbuf;}
    | _ as c { output_char !lepton_oc c; lexpr lexbuf; } | eof { flush !lepton_oc; }
and expand bplain bexp = parse
    | chunk_start  { clear buffer; let l = gobble 1 lexbuf in 
		     expand (bplain^s^(contents buffer)^l) (bexp^s^(contents buffer)^l) lexbuf; }
    | chunk_ref { let h_contents = contents (get_chunk h) in 
		  if String.length h_contents = 0 then Printf.printf "WARNING: ref <<%s>> is empty or missing.\n%!" h;
		  let _,expanded = expand "" "" (Lexing.from_string h_contents) in 
		  let indented = String.concat "" (List.map (fun s -> b^s^"\n") (Str.split (Str.regexp_string "\n") expanded)) in 
		  expand (bplain^s) (bexp^indented) lexbuf; }
    | "@@" (char* "\n"? as s) { expand (bplain^"@"^s) (bexp^"@"^s) lexbuf; }
    |       char* "\n"?  as s { expand (bplain^s) (bexp^s) lexbuf; } | eof {bplain,bexp}
and chunkref_list = parse
    | chunk_start { gobble 1 lexbuf; chunkref_list lexbuf; }
    | chunk_ref   { h :: chunkref_list lexbuf; }
    | char* "\n"? { chunkref_list lexbuf; } | eof { [] }

