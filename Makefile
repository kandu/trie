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

build_doc/index.html: trie.mli
	mkdir -p build_doc
	ocamlfind ocamldoc -package core_kernel -html -d build_doc trie.mli

.PHONY: install install-doc clean

install: lib
	ocamlfind install $(PROJECT) META *.mli *.cmi *.cma *.cmxa *.a

doc: build_doc/index.html

install-doc: build_doc/index.html
	mkdir -p $(DOCDIR)
	cp -r build_doc/* $(DOCDIR)

uninstall:
	ocamlfind remove $(PROJECT)

clean:
	rm -f *.annot *.o *.cm* *.a
	rm -rf build_doc

