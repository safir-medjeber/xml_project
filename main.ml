let help () = Printf.printf "usage:\n\t%s fichier.ged\n" Sys.argv.(0)

let ged_suffix filename = try Filename.chop_suffix filename ".ged"
	       with Invalid_argument _ ->
		 help ();
		 exit 1

let open_fic filename = try open_in filename
			with Sys_error _ -> Printf.printf "Le fichier \"%s\" n'existe pas.\n" filename;
					    exit 1

let convert filename =
  let suffix   = ged_suffix filename in
  let fic      = open_fic filename  in
  let lexbuf   = Lexing.from_channel fic in
  let ast      = Lexer.lexer 1 0 lexbuf in
  let xml      = (PrettyPrinter.print_tree ast) in
  let filename = suffix ^ ".xml" in
  let fic      = open_out filename in
  Buffer.output_buffer fic xml;
  Printf.printf "Le fichier \"%s\" a ete cree.\n" filename


let _ =
  if (Array.length Sys.argv) = 2
  then convert Sys.argv.(1)
  else help ()
