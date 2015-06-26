PROJECT= trie

CC= gcc

lib: trie.cma trie.cmxa

trie.cma: trie.ml
	ocamlfind ocamlc -package core_kernel -a -o $@ $^

trie.cmxa: trie.ml
	ocamlfind ocamlopt -package core_kernel -a -o $@ $^

trie.ml: trie.cmi


trie.cmi: trie.mli
	ocamlfind ocamlc -package core_kernel $<

.PHONY: install clean

install: lib
	ocamlfind install $(PROJECT) META *.mli *.cmi *.cma *.cmxa *.a

uninstall:
	ocamlfind remove $(PROJECT)

clean:
	rm -f *.annot *.o *.cm* *.a

