OCAMLC=ocamlc
OCAMLLEX=ocamllex
SOURCES = AST.ml lexer.ml PrettyPrinter.ml main.ml
OBJECTS = $(SOURCES:.ml=.cmo)

all: convert

convert: $(OBJECTS)
	$(OCAMLC) -o $@ $(OBJECTS)

%.cmo: %.ml
	$(OCAMLC) -c $< -o $@

%.cmi: %.mli
	$(OCAMLC) -c $< -o $@

%.ml: %.mll
	$(OCAMLLEX) $<

lexer.mll: AST.ml

lexer.cmo: AST.cmo
PrettyPrinter.cmo: AST.cmo
main.cmo: AST.cmo lexer.cmo

clean: clear
	rm -fr convert

clear:
	rm -fr lexer.ml *.cmo *.cmi *~
