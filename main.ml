let _ =
  let fic = open_in (Sys.argv.(1)) in
  let lexbuf = Lexing.from_channel fic in
  let ast =  Lexer.lexer lexbuf in
  ( AST.to_string ast)
