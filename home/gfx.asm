SECTION "Graphics", ROM0

Decompress:
.loop
	ld a, [bc]
	inc bc
	cp $80
	jr nc, .repeat_pattern

	and a
	ret z

	ld e, a
.loop_raw
	ld a, [bc]
	inc bc
	ld [hli], a
	dec e
	jr nz, .loop_raw
	jr .loop

.repeat_pattern
	add $83
	ld e, a
	ld a, [bc]
	inc bc
	push bc
	cpl
	add l
	ld c, a
	ld b, h
	jr c, .loop_repeat
	dec b
.loop_repeat
	ld a, [bc]
	ld [hli], a
	inc bc
	dec e
	jr nz, .loop_repeat

	pop bc
	jr .loop
