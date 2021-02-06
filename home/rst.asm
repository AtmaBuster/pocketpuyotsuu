SECTION "rst_00", ROM0[$0000]
RST_00::
	ldh [hFFF0], a
	ldh a, [hFF90]
	push af
	ldh a, [hFFF0]
	ldh [hFF90], a

