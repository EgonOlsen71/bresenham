; a small bresenham/graphics package for simple point plotting and line drawing for the C64

*=$c000

MEM=$2000			; graphics memory address
COLOR=$0400			; screen memory address (for colors)

MEM2=MEM-192
MEMEND=MEM+8000
TMP=$FB
VAR=$FD
JP=$A7
KP=$A9
FE=$9E
DX=$C1
DY=$C3
CF=$C4
	
	jmp init		; SYS 49152 - enable hires graphics 
	jmp reset		; SYS 49155 - disable hires graphics
	jmp clear		; SYS 49158 - clear screen with color in 780
	jmp pointplot	; SYS 49161 - plot point with X (low/high) in 780/781 and Y in 782
	jmp lineset		; SYS 49164 - set first line point with X (low/high) in 780/781 and Y in 782
	jmp linedraw	; SYS 49167 - draw line with X (low/high) in 780/781 and Y in 782
	jmp lineclear	; SYS 49170 - clear line with X (low/high) in 780/781 and Y in 782
	jmp pointclear	; SYS 49173 - clear point with X (low/high) in 780/781 and Y in 782

init:
	; modify this to use some other VIC II bank
	lda $d018
	ora #$8
	sta $d018
	lda $d011
	ora #$20
	sta $d011
	rts
	
reset:
	; modify this to use some other VIC II bank
	lda $d011
	and #$df
	sta $d011
	lda $d018
	and #$f7
	sta $d018
	rts
	
clear:
	pha
	ldy #$0
	lda #<MEMEND
	sta TMP
	lda #>MEMEND
	sta TMP+1
	dec TMP+1
	lda #0
loop1:
	sta (TMP),y
	iny
	bne loop1
	ldx TMP+1
	dec TMP+1
	cpx #>MEM
	bcc done1
	bne cont1
	ldy #$c0
	lda #<MEM2
	sta TMP
	lda #>MEM2
	sta TMP+1
cont1:
	lda #0
	jmp loop1
done1:
	pla
	
	ldx #$c7
loop2:
	sta COLOR,x
	sta COLOR+200,x
	sta COLOR+400,x
	sta COLOR+600,x
	sta COLOR+800,x
	dex
	cpx #$ff
	bne loop2
	rts
	
lineset:
	sta COORDS
	stx COORDS+1
	sty COORDS+2
	rts

lineclear:
	pha
	lda #$0
	jmp linedraw2
	
linedraw:
	pha
	lda #$1
linedraw2:
	sta CF
	pla
	sta COORDS+3
	stx COORDS+4
	sty COORDS+5
	
	ldx #5
copy:
	lda COORDS,x
	sta CALC,x
	dex
	cpx #$ff
	bne copy
	
	lda CALC+2
	cmp CALC+5
	bcc yok
	ldy CALC+5		; swap y
	sty CALC+2
	sta CALC+5
yok:
	lda CALC+1
	cmp CALC+4
	bcc xok
	bne swapx
	lda CALC
	cmp CALC+3
	bcc xok
swapx:				; swap x
	lda CALC
	ldy CALC+3
	sta CALC+3
	sty CALC
	lda CALC+1
	ldy CALC+4
	sta CALC+4
	sty CALC+1
xok:				
	sec				; calculate DY
	lda CALC+5	
	sbc CALC+2
	sta DY
		
	sec				; calculate DX
	lda CALC+3
	sbc CALC
	sta DX
	lda CALC+4
	sbc CALC+1
	sta DX+1
	
	lda DX+1
	bne contline
	lda DX
	ora DY
	bne contline
	jmp lineplot	; Just one pixel, then draw it and exit
	
contline:	
	lda COORDS+4
	cmp COORDS+1
	bcc skip1
	bne ycheck1
	lda COORDS+3
	cmp COORDS
	bcc skip1
ycheck1:
	lda COORDS+2
	cmp COORDS+5
	bcc yskip1
	
	jsr drawline300
	rts
yskip1: 
	jsr drawline700
	rts
	
skip1:	
	lda COORDS+2
	cmp COORDS+5
	bcs yskip2
	jsr drawline900
	rts

yskip2:
	jsr drawline500
	rts

drawline300:
	lda DX+1
	bne dcont1
	lda DX
	cmp DY
	bcs dcont1
	jsr drawline400
	rts
	
dcont1:	
	jsr fedx
	jsr lineplot
	lda COORDS
	sta JP
	lda COORDS+1
	sta JP+1
	inc JP
	bne	dskip1
	inc JP+1
dloop1:
dskip1:
	sec
	lda FE
	sbc DY
	sta FE
	bcs dksip2
	dec FE+1
	bpl dksip2
	dec KP
	clc
	lda DX
	adc FE
	sta FE
	lda DX+1
	adc FE+1
	sta FE+1
dksip2:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda JP
	cmp COORDS+3
	bne cloop1
	lda JP+1
	cmp COORDS+4
	bne cloop1
	rts
cloop1:
	inc JP
	bne dskip3
	inc JP+1
dskip3:
	jmp dloop1
	
drawline400:
	jsr fedy
	jsr lineplot
	lda COORDS+2
	sta KP
	lda #0
	sta KP+1
	lda KP
	bne decskip23
	dec KP+1
decskip23:
	dec KP

dloop2:
dskip4:
	sec
	lda FE
	sbc DX
	sta FE
	lda FE+1
	sbc DX+1
	sta FE+1
	bpl dksip5
	inc JP
	bne dskip4_1
	inc JP+1
dskip4_1:
	clc
	lda FE
	adc DY
	sta FE
	bcc dksip5
	inc FE+1
dksip5:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda KP
	cmp COORDS+5
	beq xloop2
	lda KP
	bne decskip6
	dec KP+1
decskip6:
	dec KP
	jmp dloop2
xloop2:
	rts

drawline500:
	lda DX+1
	bne dcont3
	lda DX
	cmp DY
	bcs dcont3
	jsr drawline600
	rts
	
dcont3:	
	jsr fedx
	jsr lineplot
	lda COORDS
	sta JP
	lda COORDS+1
	sta JP+1
	lda JP
	bne decskip7
	dec JP+1
decskip7:
	dec JP
dloop3:
	sec
	lda FE
	sbc DY
	sta FE
	bcs dksip8
	dec FE+1
	bpl dksip8
	dec KP
	clc
	lda DX
	adc FE
	sta FE
	lda DX+1
	adc FE+1
	sta FE+1
dksip8:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda JP
	cmp COORDS+3
	bne cloop3
	lda JP+1
	cmp COORDS+4
	bne cloop3
	rts
cloop3:
	lda JP
	bne decskip9
	dec JP+1
decskip9:
	dec JP
	jmp dloop3
	
drawline600:
	jsr fedy
	jsr lineplot
	lda COORDS+2
	sta KP
	lda #0
	sta KP+1
	dec KP
	bne	dskip10
	dec KP+1
dloop4:
dskip10:
	sec
	lda FE
	sbc DX
	sta FE
	lda FE+1
	sbc DX+1
	sta FE+1
	bpl dksip11
	lda JP
	bne decskip10
	dec JP+1
decskip10:
	dec JP
	clc
	lda FE
	adc DY
	sta FE
	bcc dksip11
	inc FE+1
dksip11:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda KP
	cmp COORDS+5
	beq xloop4
	lda KP
	bne decskip12
	dec KP+1
decskip12:
	dec KP
	jmp dloop4
xloop4:
	rts
	
drawline700:
	lda DX+1
	bne dcont5
	lda DX
	cmp DY
	bcs dcont5
	jsr drawline800
	rts
	
dcont5:	
	jsr fedx
	jsr lineplot
	lda COORDS
	sta JP
	lda COORDS+1
	sta JP+1
	inc JP
	bne	dskip13
	inc JP+1
dloop5:
dskip13:
	sec
	lda FE
	sbc DY
	sta FE
	bcs dksip14
	dec FE+1
	bpl dksip14
	inc KP
	clc
	lda DX
	adc FE
	sta FE
	lda DX+1
	adc FE+1
	sta FE+1
dksip14:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda JP
	cmp COORDS+3
	bne cloop5
	lda JP+1
	cmp COORDS+4
	bne cloop5
	rts
cloop5:
	inc JP
	bne dskip15
	inc JP+1
dskip15:
	jmp dloop5
	
	
drawline800:
	jsr fedy
	jsr lineplot
	lda COORDS+2
	sta KP
	lda #0
	sta KP+1
	inc KP
	bne	dskip16
	inc KP+1
dloop6:
dskip16:
	sec
	lda FE
	sbc DX
	sta FE
	lda FE+1
	sbc DX+1
	sta FE+1
	bpl dksip17
	inc JP
	bne dskip16_1
	inc JP+1
dskip16_1:
	clc
	lda FE
	adc DY
	sta FE
	bcc dksip17
	inc FE+1
dksip17:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda KP
	cmp COORDS+5
	beq xloop6
	inc KP
	bne dskip18
	inc KP+1
dskip18:
	jmp dloop6
xloop6:
	rts
	
drawline900:
	lda DX+1
	bne dcont6
	lda DX
	cmp DY
	bcs dcont6
	jsr drawlinex000
	rts
	
dcont6:	
	jsr fedx
	jsr lineplot
	lda COORDS
	sta JP
	lda COORDS+1
	sta JP+1
	lda JP
	bne decskip24
	dec JP+1
decskip24:
	dec JP
		
dloop7:
dskip19:
	sec
	lda FE
	sbc DY
	sta FE
	bcs dksip20
	dec FE+1
	bpl dksip20
	inc KP
	clc
	lda DX
	adc FE
	sta FE
	lda DX+1
	adc FE+1
	sta FE+1
dksip20:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda JP
	cmp COORDS+3
	bne cloop7
	lda JP+1
	cmp COORDS+4
	bne cloop7
	rts
cloop7:
	lda JP
	bne decskip21
	dec JP+1
decskip21:
	dec JP
	jmp dloop7
	
drawlinex000:
	jsr fedy
	jsr lineplot
	lda COORDS+2
	sta KP
	lda #0
	sta KP+1
	inc KP
	bne	dskip22
	inc KP+1
dloop8:
dskip22:
	sec
	lda FE
	sbc DX
	sta FE
	lda FE+1
	sbc DX+1
	sta FE+1
	bpl dksip23
	lda JP
	bne decskip22
	dec JP+1
decskip22:
	dec JP
	clc
	lda FE
	adc DY
	sta FE
	bcc dksip23
	inc FE+1
dksip23:
	lda JP
	ldx JP+1
	ldy KP
	jsr plot
	lda KP
	cmp COORDS+5
	beq xloop8
	inc KP
	bne dskip24
	inc KP+1
dskip24:
	jmp dloop8
xloop8:
	rts
	
fedx:
	lda DX+1
	clc
	ror
	sta FE+1
	lda DX
	ror
	sta FE
	rts
	
fedy:
	lda DY
	clc
	ror
	sta FE
	lda #0
	sta FE+1
	rts

pointclear:
	pha
	lda #$0
	sta CF
	pla
	jmp plot

pointplot:
	pha
	lda #$1
	sta CF
	pla
	jmp plot

lineplot:	
	lda COORDS
	ldx COORDS+1
	ldy COORDS+2
	sta JP
	stx JP+1
	sty KP
		
plot:
	cpy #200
	bcs exit
	cpx #0
	beq ok
	cpx #2
	bcs exit
	cmp #64
	bcs exit
	jmp ok
exit:
	rts
ok: 
	pha
	and #$f8
	sta TMP
	stx TMP+1
	lda #<MEM
	clc
	adc TMP
	sta TMP
	lda #>MEM
	adc TMP+1
	sta TMP+1
	tya
	and #$f8
	sta VAR
	lda #0
	sta VAR+1
	clc
	rol VAR
	rol VAR+1
	rol VAR
	rol VAR+1
	rol VAR
	rol VAR+1
	rol VAR
	rol VAR+1
	rol VAR
	rol VAR+1
	lda TMP
	clc
	adc VAR
	sta TMP
	lda TMP+1
	adc VAR+1
	sta TMP+1
	
	tya
	and #$f8
	sta VAR
	lda #0
	sta VAR+1
	clc
	rol VAR
	rol VAR+1
	rol VAR
	rol VAR+1
	rol VAR
	rol VAR+1
	lda TMP
	clc
	adc VAR
	sta TMP
	lda TMP+1
	adc VAR+1
	sta TMP+1
	
	tya
	and #$7
	clc
	adc TMP
	sta TMP
	bcc noov
	inc TMP+1
noov:
	pla
	and #$7
	tax
	ldy #0
	lda CF
	beq clearpoint
	lda (TMP),y
	ora VALS,x
	sta (TMP),y
	rts
	
clearpoint:
	lda VALS,x
	eor #$ff
	sta VAR
	lda (TMP),y
	and VAR
	sta (TMP),y
	rts

VALS:
	.byte 128 64 32 16 8 4 2 1
	
COORDS
	.byte 0 0 0 0 0 0
	
CALC
	.byte 0 0 0 0 0 0
	



	