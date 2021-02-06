; requires rgbds 0.4.2 or newer.
; might work on older versions but hasn't been tested
MAJOR EQU 0
MINOR EQU 4
PATCH EQU 2

if !DEF(__RGBDS_MAJOR__) || !DEF(__RGBDS_MINOR__) || !DEF(__RGBDS_PATCH__)
	fail "pokecrystal requires rgbds {MAJOR}.{MINOR}.{PATCH} or newer."
elif (__RGBDS_MAJOR__ < MAJOR) || \
	(__RGBDS_MAJOR__ == MAJOR && __RGBDS_MINOR__ < MINOR) || \
	(__RGBDS_MAJOR__ == MAJOR && __RGBDS_MINOR__ == MINOR && __RGBDS_PATCH__ < PATCH)
	fail "pokecrystal requires rgbds {MAJOR}.{MINOR}.{PATCH} or newer."
endc
