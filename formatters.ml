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
open Printf;; open Lepton;;
let tex = let r = Str.regexp_string "_" in fun s -> Str.global_replace r "\\_" s ;;
let send_to_latex_minted = fun name o reflist chunk output ->
  let plain s = fprintf !lepton_oc "%s%!" s
  and leptonchunk s = function | "hide" -> () | "verb" -> fprintf !lepton_oc "%s%!" s;
    | format -> fprintf !lepton_oc "\\b\101gin{minted}[frame=single,fontsize=\\footnotesize]{%s}\n%s\\\101nd{minted}\n%!" format s
  and leptonfloat_begin () = 
    fprintf !lepton_oc "\\b\101gin{leptonfloat}\n\\caption{%s%s}\\label{%s}\n%!"
      (tex name) (if o.part_number = 1 then "" else sprintf " (part %i)" o.part_number)
      (if o.part_number = 1 then name else name ^ string_of_int o.part_number);
    fprintf !lepton_oc "\\vspace*{-\\leptonlb}\\footnotesize{\\texttt{%s}}\\vspace*{-\\leptonlc}\n%!" 
      (String.concat "\\, " (List.map (fun d -> Printf.sprintf "\\index{%s}\\hyperref[%s]{%s}" (tex d) d (tex d)) reflist));
  and leptonfloat_end () = fprintf !lepton_oc "\\\101nd{leptonfloat}\n%!"; in
  match o.chunk_format with
    | "hide" | "verb" -> if o.chunk_format = "verb" then plain chunk;
      if o.interpreter <> "none" then leptonchunk output o.output_format
    | f1 -> leptonfloat_begin (); leptonchunk chunk f1; 
      match o.interpreter,o.output_format with
	| "none",_ |  _, "hide" -> leptonfloat_end ();
	| _, "verb" -> leptonfloat_end (); plain output;
	| _, f2 -> plain ("\\vspace*{-\\leptonld}Interpret with \\texttt{" ^ tex o.interpreter ^ "}\\vspace*{-\\leptonle}\n"); 
	  leptonchunk output f2; leptonfloat_end ();
;;
let substitute_split s rexp ftext fdelim = let open Str in
  String.concat "" 
    (List.map (function | Text m -> ftext m | Delim m -> ignore (string_match rexp m 0); fdelim m) (full_split rexp s))
;;
let rexp_ref = Str.regexp "^\\([ \t]*\\)<\060\\(.*\\)>>\n";;
let send_to_tex name o reflist chunk output = (* echo to documentation, in plain TeX format *)
  let plain s = Printf.fprintf !lepton_oc "%s%!" s
  and leptonchunk s = function | "hide" -> () | "verb" -> Printf.fprintf !lepton_oc "%s%!" s;
    | format -> Printf.fprintf !lepton_oc "\\b\101gin{verbatim}\n%s\\\101nd{verbatim}\n%!" s
  and leptonfloat_begin () = 
    Printf.fprintf !lepton_oc "\\b\101gin{leptonfloat}\n\\caption{%s%s}\n\\label{%s}"
      (tex name) (if o.part_number = 1 then "" else Printf.sprintf " (part %i)" o.part_number)
      (if o.part_number = 1 then name else name ^ string_of_int o.part_number);
    Printf.fprintf !lepton_oc "\\vspace*{-\\leptonlb}\\footnotesize{\\texttt{%s}}\\vspace*{-\\leptonlc}\n" 
      (substitute_split chunk rexp_ref (fun _ -> "") (fun d0 -> let d = Str.matched_group 2 d0 in Printf.sprintf "\\index{%s}\\hyperref[%s]{%s}\\, " (tex d) d (tex d))); 
  and leptonfloat_end () = Printf.fprintf !lepton_oc "\\\101nd{leptonfloat}\n%!"; in
  match o.chunk_format with
    | "hide" | "verb" -> if o.chunk_format = "verb" then plain chunk;
      if o.interpreter <> "none" then leptonchunk output o.output_format
    | f1 -> leptonfloat_begin (); leptonchunk chunk f1; 
      match o.interpreter,o.output_format with
	| "none",_ |  _, "hide" -> leptonfloat_end ();
	| _, "verb" -> leptonfloat_end (); plain output;
	| _, f2 -> plain ("\\vspace*{-\\leptonld}Interpret with \\texttt{" ^ tex o.interpreter ^ "}\\vspace*{-\\leptonle}\n"); 
	  leptonchunk output f2; leptonfloat_end ();
;;
let send_to_html name o reflist chunk output = 
  begin match o.chunk_format with
    | "hide" -> ()
    | _ -> Printf.fprintf !lepton_oc "\n<pre id=leptonchunk>\n%s</pre>\n%!" chunk ; end;
  begin match o.output_format with
    | "hide" -> ()
    | _ -> Printf.fprintf !lepton_oc "\n<pre id=leptonoutput>\n%s</pre>\n%!" output ; end;      
;;
let send_to_creole name o reflist chunk output = 
  begin match o.chunk_format with
    | "hide" -> ()
    | _ -> Printf.fprintf !lepton_oc "\n{{{\n%s}}}\n%!" chunk ; end;
  begin match o.output_format with
    | "hide" -> ()
    | _ -> Printf.fprintf !lepton_oc "\n{{{\n%s}}}\n%!" output ; end;      
;;
Lepton.formatter := send_to_latex_minted;;
let set = function
  | "latex_minted" -> Lepton.formatter := send_to_latex_minted
  | "tex"          -> Lepton.formatter := send_to_tex
  | "creole"       -> Lepton.formatter := send_to_creole
  | "html"         -> Lepton.formatter := send_to_html
  | _ -> failwith "unknown selected formatter";;
