open AST

let buffer = Buffer.create 100000
let add    = Buffer.add_string buffer

let rec print_tab n =
  if n = 0
  then ()
  else
    begin
      add "\t";
      (print_tab (n-1))
    end

let sub s = String.(sub s 1 (length s -2))

let attribut = List.fold_left (fun s (attr,value) -> Printf.sprintf " %s=\"%s\"%s" attr (sub value) s) ""

let balise prefix suffix attr tab tag = (print_tab tab);
				      add (Printf.sprintf "<%s%s%s%s>\n"
							  prefix
							  (String.lowercase tag)
							  (attribut attr)
							  suffix)

let close_balise  = balise "/" "" []
let open_balise   = balise "" ""
let closed_balise = balise "" "/"

let print_info n s =
  if s <> ""
  then begin
      print_tab n;
      add s;
      add "\n"
    end

let print_tree l =
  let rec aux n = function
    | Nil -> ()
    | Noeud(Balise(tag, atts, data), l) ->
       (print_string ("<<"^tag^">>\n"));
       if l = [] && data = ""
       then closed_balise atts n tag
       else begin
	   open_balise atts n tag;
	   print_info n data;
	   List.iter (aux (n+1)) l;
	   close_balise n tag
	 end
  in
  aux 0 (list2tree l);
  buffer

