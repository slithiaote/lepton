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
open Lepton;;
let str = string_of_float (Random.float 1.);;
register_process_creator "shell" (make_process_creator (fun _ -> Unix.open_process "sh") ("echo \"" ^ str ^ "\"\n") str) ;;
register_process_creator "python" (make_process_creator (fun _ -> Unix.open_process "python -i") ("print \"" ^ str ^ "\"\n") str);;		     
register_process_creator "R" (make_process_creator (fun _ -> Unix.open_process "R --slave") ("cat(\"" ^ str ^ "\\n\")\n") str);;
let ocaml_creator = 
  let open_proc = fun _ -> 
    (let oc_in,oc_out,oc_err = Unix.open_process_full "ocaml -noprompt" [|"TERM="|] in
    ignore(input_line oc_in); ignore(input_line oc_in); oc_in, oc_out ) in
  make_process_creator open_proc ("print_float " ^ str ^ ";;\n") (str^"- : unit = ()")
in register_process_creator "ocaml" ocaml_creator;;
let scilab_open = fun _ ->
  let entrypipe_r, entrypipe_w = Unix.pipe() and exitpipe_r, exitpipe_w = Unix.pipe() in Unix.set_nonblock entrypipe_r;
  let oc_in = Unix.in_channel_of_descr exitpipe_r and oc_out = Unix.out_channel_of_descr entrypipe_w in
  ignore(Unix.create_process_env "scilab-cli" [| "scilab-cli" |] [|"SCIHOME=/tmp"|] entrypipe_r exitpipe_w exitpipe_w);
  oc_in,oc_out;;
register_process_creator "scilab" (make_process_creator scilab_open ("disp(\"325\");\n") ("325"));;
