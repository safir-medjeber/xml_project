type t =
    Niv of int
  | Id of string
  | Info of string
  | Tag of string
  | EOF

type balise = Balise of name * attributes * data
and  name = string
and attributes = (string * string) list
and data = string

type 'a tree = Noeud of 'a * 'a tree list | Nil

let add_att  (Balise(name, atts, data)) id value = Balise(name, (id,value)::atts, data)
let set_info (Balise(name, atts, _)) info = Balise(name, atts, info)
let set_tag  (Balise(_, atts, data)) tag = Balise(tag, atts, data)

let to_balise =
  let rec aux balise before = function
    |  []       -> balise
    | Id id::l  -> if before
		   then aux (add_att balise "idref" id) before l
		   else aux (add_att balise "id" id) before l
    | Info s::l -> aux (set_info balise s) before l
    | Tag s::l  -> aux (set_tag balise s) false l
    | Niv _::_  -> assert false (* Delete all niv before *)
  in
  aux (Balise("", [], "")) true

let rec split = function
  | [] -> []
  | Niv i::l -> let l,r = ligne l
		in (i,to_balise l)::(split r)
  | _ -> assert false

and ligne l =
  let rec aux res = function
    | []    -> assert false (* doit finir par [EOF]*)
    | [EOF] -> res, []
    | Niv _::_ as w -> res, w
    | x::l          -> aux (x::res) l
  in
  aux [] l


let find_tag =
  function
  | Noeud(Balise(tag,_,_), _ ) -> tag
  | _ -> ""

let insert x l =
  let xTag = find_tag x in
  if xTag = "INDI" || xTag = "FAM"
     || xTag = "HEAD" || xTag = "TRLR"
  then x::l
  else
    let rec aux = function
      | []   -> [x]
      | y::l ->
	 let yTag = find_tag y in
	 if xTag > yTag
	 then y::(aux l)
	 else x::y::l
    in
  aux l

let rec next l niv =
  match l with
  | [] -> (Nil, [])
  | (n, _) :: _ when n <= niv -> (Nil, l)
  | (n, balise) :: l' ->
     let (children, rest) = create_abr l' n in
     (Noeud (balise, children), rest)

and create_abr l niv =
  let (abr, rest) = next l niv in
  match abr with
  | Nil -> ([], rest)
  | noeud ->
     let (abr, rest) = create_abr rest niv in
     (insert noeud abr, rest)

let list2tree l =
  let l = split (Niv (-1)::Tag "root"::l) in
  match (fst (create_abr l (-2))) with
  | [] -> Nil
  | hd :: tl -> hd
