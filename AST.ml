type t =
    Niv of int
  | Id of string
  | Info of string
  | Tag of string
  | EOF


let entete = ""
(* "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" *)

let rec print_tab n =
  if n = 0
  then ""
  else "\t" ^ (print_tab (n-1))


let print_info s n = (print_tab n) ^ s ^ "\n"

let sub s = String.(sub s 1 (length s -2))

let attribut = List.fold_left (fun s (attr,value) -> Printf.sprintf " %s=\"%s\"%s" attr (sub value) s) ""

let balise prefix suffix attr tab s = Printf.sprintf "%s<%s%s%s%s>\n"
						     (print_tab tab)
						     prefix
						     (String.lowercase s)
						     (attribut attr)
						     suffix



let c_balise = balise "/" "" []
let o_balise = balise "" ""  []


let c_attribute = balise "" "/"
let attribute   = balise "" ""

let rec to_string =
  function
  | Niv i::l  -> entete ^ (o_balise 0 "root") ^ (to_string' i ["root"] l)
  | [EOF]     -> ""
  | _ -> assert false

and to_string' niv balises =
  function
  | Niv i::l        -> if i <= niv
		       then close (niv-i) i balises l
		       else to_string' i balises l
  | Id id::Tag s::l -> tag_to_string s (Some id) niv balises l
  | Info s::l       -> print_info s niv ^ to_string' niv balises l
  | Tag s::l        -> tag_to_string s None niv balises l
  | EOF::l          -> close_all niv balises l

and close n niv balises l = match n,balises with
  | 0,[] -> ""
  | n,"/"::balises    when n >= 0 -> close (n-1) niv balises l
  | n,balise::balises when n >= 0 -> (c_balise (niv+n) balise)
				     ^ close (n-1) niv balises l
  | n, balises -> to_string' niv balises l

and close_all n l = close (List.length l) n l

and tag_to_string s id niv balises l =
  match s with
  | "HUSB"
  | "WIFE"
  | "CHIL"
  | "FAMC"
  | "FAMS" as s ->
     let (Id id)::l = l in
     (c_attribute ["idref",id] niv s)
     ^ to_string' niv ("/"::balises) l

  | _ as s -> let balise = match id with
		| None -> o_balise niv s
		| Some id -> attribute ["id",id] niv s
	      in
	      balise ^ (to_string' niv (s::balises) l)
