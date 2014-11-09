{ open AST }

let newline = ('\010' | '\013' | "\013\010")
let blank   = [' ' '\009' '\012']
let digit = ['0'-'9']
let lowercase_alpha = ['a'-'z' '_']
let uppercase_alpha = ['A'-'Z' '_']
let alpha = lowercase_alpha | uppercase_alpha
let alphanum = alpha | digit | '_'

let info_keywords = "INDI" | "FAM" | "NAME" | "TITL" | "SEX" | "PLAC"
	       | "DATE" | "DIV" | "BIRT" | "DEAT" | "BURI" | "MARR"
	       | "CHR" | "OBJE" | "FILE" | "FORM" | "HEAD" | "TRLR"
	       | "SOUR" | "VERS" | "VERS" | "CONT" | "CORP" | "ADDR"
	       | "PHON" | "DEST" | "CHAR" | "GEDC"

let id_keywords = "HUSB" | "WIFE" | "FAMC" | "FAMS" | "CHIL"

let ignore = blank | newline

rule lexer = parse
  | newline+ | blank+ { lexer lexbuf }

  (** Keywords *)
  | id_keywords as s { Tag s::(lexer lexbuf) }
  | info_keywords as s { Tag s::(information lexbuf) }

  | digit+ as n { Niv (int_of_string n)::lexer lexbuf }
  | '@' alphanum+ '@' as s { Id s::lexer lexbuf }

  | eof { [EOF] }
  | _ as c { failwith (Printf.sprintf "Erreur charcater %c " c) }

and information = parse
  | [^'\n']+ as s { Info s::lexer lexbuf }
  | '\n' { lexer lexbuf }
