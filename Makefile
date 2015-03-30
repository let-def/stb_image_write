all: stb_image_write.cma stb_image_write.cmxa

ml_stb_image_write.o: ml_stb_image_write.c
	ocamlc -c -ccopt "-O3 -std=gnu99 -ffast-math" $<

dll_stb_image_write_stubs.so lib_stb_image_write_stubs.a: ml_stb_image_write.o
	ocamlmklib \
	    -o _stb_image_write_stubs $< \
	    -ccopt -O3 -ccopt -std=gnu99 -ccopt -ffast-math

stb_image_write.cmi: stb_image_write.mli
	ocamlc -c $<

stb_image_write.cmo: stb_image_write.ml stb_image_write.cmi
	ocamlc -c $<

stb_image_write.cma: stb_image_write.cmo dll_stb_image_write_stubs.so
	ocamlc -a -custom -o $@ $< \
	       -ccopt -L/usr/local/lib \
	       -dllib dll_stb_image_write_stubs.so \
	       -cclib -l_stb_image_write_stubs

stb_image_write.cmx: stb_image_write.ml stb_image_write.cmi
	ocamlopt -c $<

stb_image_write.cmxa stb_image_write.a: stb_image_write.cmx dll_stb_image_write_stubs.so
	ocamlopt -a -o $@ $< \
	      -cclib -l_stb_image_write_stubs \
	  		-ccopt -O3 -ccopt -std=gnu99 -ccopt -ffast-math

.PHONY: clean-doc clean clean-mlpp run-opt-demo test install

clean: clean-doc clean-mlpp
	rm -f *.[oa] *.so *.cm[ixoa] *.cmxa

DIST_FILES=              \
	stb_image_write.a            \
	stb_image_write.cmi          \
	stb_image_write.cmo          \
	stb_image_write.cma          \
	stb_image_write.cmx          \
	stb_image_write.cmxa         \
	lib_stb_image_write_stubs.a  \
	dll_stb_image_write_stubs.so

install: $(DIST_FILES) META
	ocamlfind install stb_image_write $^

uninstall:
	ocamlfind remove stb_image_write

reinstall:
	-$(MAKE) uninstall
	$(MAKE) install
