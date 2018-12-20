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
type chunk = Doc of string | Code of string array * string;;
type option = {
  mutable part_number : int;
  mutable write : bool; mutable expand : bool; 
  mutable chunk_format: string; mutable output_format: string;
  mutable interpreter : string;
};;
let option_copy o = {o with part_number = 0};; (* independent copy of the object *)
let option_print name o = 
  Printf.printf "%s (part %i%s%s):\t" name o.part_number (if o.expand then " expand" else "") (if o.write then " write" else "");
  Printf.printf "chunk as %s, " o.chunk_format;
  if o.interpreter <> "none" then Printf.printf "exec with %s, output as %s, " o.interpreter o.output_format;  
  Printf.printf "\n%!";;
let make_get_item initial fnew = let open Hashtbl in
  let storage = create 30 in List.iter (fun (key,value) -> add storage key value) initial;
  fun key -> try find storage key with Not_found -> (add storage key (fnew key); find storage key);;
let get_chunk = make_get_item [] (fun (s:string) -> Buffer.create 100);;
let send_to_file = let get_file = make_get_item [] open_out in 
  fun msg file_name -> let oc = (get_file file_name) in output_string oc msg; flush oc;;
let split_header = fun s -> Array.of_list (Str.split (Str.regexp "[ \t]+") s);;
let parse_chunklabel = (* Parse the chunk label into name, option structure *)
  let defaults = { part_number=0; write=false; expand=false; chunk_format="text"; output_format="hide"; interpreter="none"; } in
  let get_option = make_get_item [("lepton_options",defaults)] (fun _ -> option_copy defaults) in
  function args ->
    let o = get_option args.(0) in o.part_number <- o.part_number + 1;
    let option_spec = 
      ("-write", Arg.Unit (fun _ -> o.write <- true) , "write chunk to disk") :: 
      ("-nowrite", Arg.Unit (fun _ -> o.write <- false) , "do not write chunk to disk (default)") :: 
      ("-expand", Arg.Unit (fun _ -> o.expand <- true) , "expand chunk in documentation") ::
      ("-noexpand", Arg.Unit (fun _ -> o.expand <- false) , "do not expand chunk in documentation (default)") ::
      ("-chunk", Arg.String (fun s -> o.chunk_format <- s), "chunk type for pretty-printing") ::
      ("-output", Arg.String (fun s -> o.output_format <- s), "output type for pretty-printing") ::
      ("-exec", Arg.String (fun s -> o.interpreter <- s; o.output_format <- "text"), "send chunk to external interpreter") :: [] in
    Arg.parse_argv ~current:(ref 0) args option_spec (fun _ -> ()) "Wrong option in chunk header.\nusage : "; option_print args.(0) o; o;;
let process_creators = ref [("none",fun () -> (fun (s:string) -> ""))];;
let register_process_creator name f = process_creators := (name,f) :: !process_creators;;
let send_to_interpreter = (* return output of external chunk interpretation *)
  let rec assoc_prefix name = function
    | (key,value)::_ when String.length name >= String.length key && key = String.sub name 0 (String.length key) -> value 
    | a :: b -> assoc_prefix name b | [] -> failwith ("send_to_interpreter : cannot find " ^ name) in
  let get_process = make_get_item [] (fun process_name -> (assoc_prefix process_name !process_creators) ()) in
  fun msg process_name -> (get_process process_name) msg;;
let make_process_creator open_process question answer = fun () -> 
  let (oc_in,oc_out) = open_process () and l = ref "" and b = Buffer.create 10 in 
  let rexp_answer = Str.regexp ("\\(.*\\)"^answer) in
  fun msg -> Printf.fprintf oc_out "%s%s%!" msg question; (* Printf.printf "%s%s%!" msg question; *)
    Buffer.clear b; while (l := input_line oc_in;not (Str.string_match rexp_answer !l 0)) 
      do Buffer.add_string b (!l ^ "\n") done; Buffer.contents b ^ Str.matched_group 1 !l;;
let lepton_ic = ref stdin;;
let lepton_oc = ref stdout;; 
let formatter = ref (fun (name:string) o (l:string list) (chunk:string) (output:string) -> ignore(o.write) );;
