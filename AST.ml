type t =
    Niv of int
  | Id of string
  | Info of string
  | Tag of string
  | EOF


let rec print_tab n =
  if n = 0
  then ""
  else "\t" ^ (print_tab (n-1))

let print_info s n = (print_tab n) ^ s ^ "\n"

let c_balise n s = (print_tab n) ^ "</" ^ (String.lowercase s) ^ ">\n"
let o_balise n s = (print_tab n) ^ "<" ^ (String.lowercase s) ^ ">\n"

let pre_attribute n s attr value = (print_tab n) ^ "<" ^ (String.lowercase s) ^ " " ^ attr ^ "=\"" ^ value
let c_attribute n s attr value = (pre_attribute n s attr value) ^ "\"/>\n"
let attribute n s attr value = (pre_attribute n s attr value) ^ "\">\n"

let rec to_string =
  function
  | Niv i::l  -> to_string' i [] l
  | [EOF]     -> ""
  | _ -> assert false

and to_string' niv balises =
  function
  | Niv i::l  -> if i <= niv
		 then close (niv-i) i balises l
		 else to_string' i balises l
  | Id id::Tag s::l   -> tag_to_string s (Some id) niv balises l
  | Info s::l -> print_info s niv ^ to_string' niv balises l
  | Tag s::l  -> tag_to_string s None niv balises l
  | EOF::l    -> close_all niv balises l

and close n niv balises l = match n,balises with
  | 0,[] -> ""
  | n,"/"::balises when n >= 0 -> close (n-1) niv balises l
  | n,balise::balises when n >= 0 -> (c_balise (niv+n) balise)
				     ^ close (n-1) niv balises l
  | n, balises -> to_string' niv balises l

and close_all n l = close (List.length l) n l

and tag_to_string s id niv balises l =
  match s with
  | "HUSB" | "WIFE" | "CHIL" | "FAMC" | "FAMS" as s ->
					 let (Id id)::l = l in
				         (c_attribute niv s "idref" id)
					 ^ to_string' niv ("/"::balises) l
  | _ as s -> let balise = match id with
	      | None -> o_balise niv s
	      | Some id -> attribute niv s "id" id
	      in
	      balise ^ (to_string' niv (s::balises) l)
