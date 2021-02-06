# aped from pret/pokecrystal

rom := pockettsuu.gb

rom_obj := \
home.o \
main.o \
wram.o

### Build tools

ifeq (,$(shell which sha1sum))
SHA1 := shasum
else
SHA1 := sha1sum
endif

RGBDS ?=
RGBASM  ?= $(RGBDS)rgbasm
RGBFIX  ?= $(RGBDS)rgbfix
RGBGFX  ?= $(RGBDS)rgbgfx
RGBLINK ?= $(RGBDS)rgblink

### Build targets
.SUFFIXES:
.PHONY: all clean tidy compare tools

all: pockettsuu.gb

clean: tidy
	find . \( -iname '*.1bpp' -o -iname '*.2bpp' \) -delete

tidy:
	rm -f $(rom) $(rom_obj) $(rom:.gb=.map) $(rom:.gb=.sym) rgbdscheck.o
	$(MAKE) clean -C tools/

compare: $(rom)
	@$(SHA1) -c roms.sha1

tools:
	$(MAKE) -C tools/

RGBASMFLAGS = -L -Weverything

rgbdscheck.o: rgbdscheck.asm
	$(RGBASM) -o $@ $<

define DEP
$1: $2 $$(shell tools/scan_includes $2) | rgbdscheck.o
	$$(RGBASM) $$(RGBASMFLAGS) -o $$@ $$<
endef

# Build tools when building the rom.
# This has to happen before the rules are processed, since that's when scan_includes is run.
ifeq (,$(filter clean tidy tools,$(MAKECMDGOALS)))

$(info $(shell $(MAKE) -C tools))

$(foreach obj, $(rom_obj), $(eval $(call DEP,$(obj),$(obj:.o=.asm))))

endif

fix_opt = -vs -r 0 -n 0 -m 1 -l 0x33 -k BJ -t "POCKET PUYOPUYO2"

pockettsuu.gb: $(rom_obj) layout.link baserom.gb
	$(RGBLINK) -n pockettsuu.sym -m pockettsuu.map -l layout.link -O baserom.gb -o $@ $(filter %.o,$^)
	$(RGBFIX) $(fix_opt) $@ 2>/dev/null

%.2bpp: %.png
	rgbgfx -o $@ $<

%.1bpp: %.png
	rgbgfx -d1 -o $@ $<
