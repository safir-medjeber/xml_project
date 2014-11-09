OCAMLC=ocamlc
OCAMLLEX=ocamllex
SOURCES = AST.ml lexer.ml main.ml
                                                                               OBJECTS = $(SOURCES:.ml=.cmo)

all: convert

convert: AST.cmo lexer.cmo main.cmo
	$(OCAMLC) -o $@ $(OBJECTS)

%.cmo: %.ml
	$(OCAMLC) -c $< -o $@

%.cmi: %.mli
	$(OCAMLC) -c $< -o $@

%.ml: %.mll
	$(OCAMLLEX) $<

lexer.mll: AST.ml

lexer.cmo: AST.cmo
main.cmo: AST.cmo lexer.cmo

clean: clear
	rm -fr convert

clear:
	rm -fr lexer.ml *.cmo *.cmi *~
