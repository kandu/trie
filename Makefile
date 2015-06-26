PROJECT= trie

CC= gcc

lib: trie.cma trie.cmxa

trie.cma trie.cmxa: trie.ml
	ocamlfind ocamlmklib -package core_kernel -ltrie -o trie -oc trie_stubs $^

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

