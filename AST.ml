type t =
    Niv of int
  | Id of string
  | Info of string
  | Tag of string
  | EOF

(* type t = record list *)

(*  and record = line list *)

(*  and line = IdentifiedLine of niveau * identifier * tag *)
(* 	  | TypicalLine of niveau * tag * information option *)

(*  and niveau = Niv of int *)

(*  and identifier = Id of string *)

(*  and tag = Tag of string *)

(*  and information = Info of string *)


let c_balise s = "</" ^ s ^ ">"
let o_balise s = "<" ^ s ^ ">"

let c_attribute s attr value = "<" ^ s ^ " " ^ attr ^ "=\"" ^ value ^ "\"/>"
let attribute s attr value = "<" ^ s ^ " " ^ attr ^ "=\"" ^ value ^ "\">"

let close_all l = List.iter (fun s -> print_string ((c_balise s) ^ "\n")) l

let rec to_string =
  function
  | Niv i::l  -> to_string' i [] l
  | [EOF]     -> ()
  | _ -> assert false

and to_string' niv balises =
  print_string "\n";
  function
  | Niv i::l  -> if i <= niv
		 then close (niv-i) i balises l
		 else to_string' i balises l
  | Id id::Tag s::l   -> tag_to_string s (Some id) niv balises l
  | Info s::l -> print_string s; to_string' niv balises l
  | Tag s::l -> tag_to_string s None niv balises l
  | EOF::l    -> close_all balises

and close n niv balises l = match n,balises with
  | 0,[] -> ()
  | n,"/"::balises when n >= 0 -> close (n-1) niv balises l

  | n,balise::balises when n >= 0 -> print_string (c_balise balise);
				     print_string "\n";
				    close (n-1) niv balises l
  | n, balises -> to_string' niv balises l

and tag_to_string s id niv balises l =
  match s with
  | "HUSB" | "WIFE" | "CHIL" | "FAMC" | "FAMS" as s ->
					 let (Id id)::l = l in
					 print_string (c_attribute s "idref" id);
					 to_string' niv ("/"::balises) l
  | _ as s -> match id with
	      | None -> print_string (o_balise s);
			to_string' niv (s::balises) l
	      | Some id -> print_string (attribute s "id" id);
			   to_string' niv (s::balises) l
