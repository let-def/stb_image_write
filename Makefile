OCAMLC=ocamlc
OCAMLOPT=ocamlopt
OCAMLMKLIB=ocamlmklib

EXT_DLL=$(shell $(OCAMLC) -config | grep ext_dll | cut -f 2 -d ' ')
EXT_LIB=$(shell $(OCAMLC) -config | grep ext_lib | cut -f 2 -d ' ')
EXT_OBJ=$(shell $(OCAMLC) -config | grep ext_obj | cut -f 2 -d ' ')

CFLAGS=-O3 -std=gnu99 -ffast-math

all: stb_image_write.cma stb_image_write.cmxa

ml_stb_image_write$(EXT_OBJ): ml_stb_image_write.c
	$(OCAMLC) -c -ccopt "$(CFLAGS)" $<

dll_stb_image_write_stubs$(EXT_DLL) lib_stb_image_write_stubs$(EXT_LIB): ml_stb_image_write$(EXT_OBJ)
	$(OCAMLMKLIB) -o _stb_image_write_stubs $<

stb_image_write.cmi: stb_image_write.mli
	$(OCAMLC) -c $<

stb_image_write.cmo: stb_image_write.ml stb_image_write.cmi
	$(OCAMLC) -c $<

stb_image_write.cma: stb_image_write.cmo dll_stb_image_write_stubs$(EXT_DLL)
	$(OCAMLC) -a -custom -o $@ $< \
	       -dllib dll_stb_image_write_stubs$(EXT_DLL) \
	       -cclib -l_stb_image_write_stubs

stb_image_write.cmx: stb_image_write.ml stb_image_write.cmi
	$(OCAMLOPT) -c $<

stb_image_write.cmxa stb_image_write$(EXT_LIB): stb_image_write.cmx dll_stb_image_write_stubs$(EXT_DLL)
	$(OCAMLOPT) -a -o $@ $< \
	       -cclib -l_stb_image_write_stubs

.PHONY: clean install uninstall reinstall

clean:
	rm -f *$(EXT_LIB) *$(EXT_OBJ) *$(EXT_DLL) *.cm[ixoa] *.cmxa

DIST_FILES=                    \
	stb_image_write$(EXT_LIB)    \
	stb_image_write.cmi          \
	stb_image_write.cmo          \
	stb_image_write.cma          \
	stb_image_write.cmx          \
	stb_image_write.cmxa         \
	stb_image_write.ml           \
	stb_image_write.mli          \
	lib_stb_image_write_stubs$(EXT_LIB)  \
	dll_stb_image_write_stubs$(EXT_DLL)

install: $(DIST_FILES) META
	ocamlfind install stb_image_write $^

uninstall:
	ocamlfind remove stb_image_write

reinstall:
	-$(MAKE) uninstall
	$(MAKE) install
