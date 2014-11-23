{ open AST }

let newline = ('\010' | '\013' | "\013\010")
let blank   = [' ' '\009' '\012']
let digit = ['0'-'9']
let lowercase_alpha = ['a'-'z' '_']
let uppercase_alpha = ['A'-'Z' '_']
let alpha = lowercase_alpha | uppercase_alpha
let alphanum = alpha | digit | '_'

let info_keywords = "INDI" | "FAM" | "TITL" | "SEX" | "PLAC"
	       | "DATE" | "DIV" | "BIRT" | "DEAT" | "BURI" | "MARR"
	       | "CHR" | "OBJE" | "FILE" | "FORM" | "HEAD" | "TRLR"
	       | "SOUR" | "VERS" | "VERS" | "CONT" | "CORP" | "ADDR"
	       | "PHON" | "DEST" | "CHAR" | "GEDC"
	       (* Royal keywords *)
	       | "SUBM" | "COMM" | "REFN"
	       (* French keywords *)
	       | "NUMB" | "ILLE" | "CHAN" | "QUAY" | "MISC" | "OCCU" | "NOTE" | "ATTR" | "STIL" | "BAPM" | "ANUL" | "ENGA"

let id_keywords = "HUSB" | "WIFE" | "FAMC" | "FAMS" | "CHIL"

let ignore = blank | newline


rule lexer n niv =
 parse
  | newline+ | blank+ { lexer n niv lexbuf }

  (** Keywords *)
  | "NAME"        as s { Tag s::firstname n (niv+1) lexbuf }
  | id_keywords   as s { Tag s::(lexer n niv lexbuf) }
  | info_keywords as s { Tag s::(information "" n niv lexbuf) }

  | digit+ as i { let i = (int_of_string i) in Niv i::lexer (n+1) i lexbuf }
  | '@' alphanum+ '@' as s { Id s::lexer n niv lexbuf }

  | eof { [EOF] }
  | _ as c { failwith (Printf.sprintf "Erreur charcater %c, ligne %d" c n) }

and information s n niv = parse
  | '&' { information (s^"&amp;") n niv lexbuf }
  | [^ '\010' '\013' '&']+ as s' { information (s^s') n niv lexbuf }
  | newline { if s = ""
	      then lexer n niv lexbuf
	      else Info s::lexer n niv lexbuf }

and firstname n niv = parse
	   | [^ '\010' '\013' '/']+ as s { Niv niv::Tag "fname"::Info s::firstname n niv lexbuf }
	   | '/' { lastname n niv lexbuf }
	   | newline { lexer n (niv -1) lexbuf }

and lastname n niv = parse
  | [^ '\010' '\013' '/']+ as s { Niv niv::Tag "lname"::Info s::lastname n niv lexbuf }
  | '/' { nickname n niv lexbuf }
  | newline { lexer n (niv -1) lexbuf }

and nickname n niv = parse
  |  [^ '\010' '\013' ]+ as s { Niv niv::Tag "nname"::Info s::nickname n niv lexbuf}
  | newline { lexer n (niv -1) lexbuf }
