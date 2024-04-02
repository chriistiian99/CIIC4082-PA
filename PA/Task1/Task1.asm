.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
  RTI
.endproc

.proc nmi_handler
  LDA #$00
  STA OAMADDR
  LDA #$02
  STA OAMDMA
	LDA #$00
	STA $2005
	STA $2005
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
  load_palettes:
    LDA palettes,X
    STA PPUDATA
    INX
    CPX #$20            ;Updated for new palettes (16dec per palette, 20hex = 32 dec)
    BNE load_palettes

   ; write sprite data
   LDX #$00
load_sprites:
  LDA sprites,X
  STA $0200,X
  INX
  CPX #$80              ;Loads 8 sprites
  BNE load_sprites

  ; write nametables
  ; 1st block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$44
  STA PPUADDR
  LDX #$26
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$45
  STA PPUADDR
  LDX #$27
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$64
  STA PPUADDR
  LDX #$36
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$65
  STA PPUADDR
  LDX #$37
  STX PPUDATA

  ;2nd Block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$48
  STA PPUADDR
  LDX #$28
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$49
  STA PPUADDR
  LDX #$29
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$68
  STA PPUADDR
  LDX #$38
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$69
  STA PPUADDR
  LDX #$39
  STX PPUDATA

  ;3rd block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$4C
  STA PPUADDR
  LDX #$2A
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$4D
  STA PPUADDR
  LDX #$2B
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$6C
  STA PPUADDR
  LDX #$3A
  STX PPUDATA

  ;4th block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$50
  STA PPUADDR
  LDX #$2C
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$51
  STA PPUADDR
  LDX #$2D
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$70
  STA PPUADDR
  LDX #$3C
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$71
  STA PPUADDR
  LDX #$3D
  STX PPUDATA

  ;5th block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$C4
  STA PPUADDR
  LDX #$2E
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$C5
  STA PPUADDR
  LDX #$2F
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$E4
  STA PPUADDR
  LDX #$3E
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$E5
  STA PPUADDR
  LDX #$3F
  STX PPUDATA

  ;6th block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$C8
  STA PPUADDR
  LDX #$30
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$C9
  STA PPUADDR
  LDX #$31
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$E8
  STA PPUADDR
  LDX #$40
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$E9
  STA PPUADDR
  LDX #$41
  STX PPUDATA

  ;7th block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$CC
  STA PPUADDR
  LDX #$32
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$CD
  STA PPUADDR
  LDX #$33
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$EC
  STA PPUADDR
  LDX #$42
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$ED
  STA PPUADDR
  LDX #$43
  STX PPUDATA

  ;8th block
  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$D0
  STA PPUADDR
  LDX #$34
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$D1
  STA PPUADDR
  LDX #$35
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$F0
  STA PPUADDR
  LDX #$44
  STX PPUDATA

  LDA PPUSTATUS
  LDA #$22
  STA PPUADDR
  LDA #$F1
  STA PPUADDR
  LDX #$45
  STX PPUDATA

  ; finally, attribute table
	LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$EB
	STA PPUADDR
	LDA #%01010101
	STA PPUDATA

  LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$E2
	STA PPUADDR
	LDA #%11111111
	STA PPUDATA

  LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$EA
	STA PPUADDR
	LDA #%11111111
	STA PPUDATA

  LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$E4
	STA PPUADDR
	LDA #%10101010
	STA PPUDATA

  LDA PPUSTATUS
	LDA #$23
	STA PPUADDR
	LDA #$EC
	STA PPUADDR
	LDA #%10101010
	STA PPUDATA

vblankwait:       ; wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000  ; turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110  ; turn on screen
  STA PPUMASK

forever:
  JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "sprites.chr"

.segment "RODATA"
palettes:
.byte $0f, $07, $17, $37    ;Palette 0 BROWN ;Background Palettes
.byte $0f, $15, $27, $26    ;Palette 1 FIRE
.byte $0f, $38, $39, $3A    ;Palette 2 Light Yellow/Green
.byte $0f, $2A, $2B, $2C    ;Palette 3 GREEN

.byte $0f, $00, $10, $30    ;Palette 0 BLACK/GREY ;Sprite Palettes
.byte $0f, $01, $21, $31    ;Palette 1 BLUE
.byte $0f, $06, $16, $26    ;Palette 2 RED/PINK
.byte $0f, $09, $19, $29    ;Palette 3 GREEN

sprites:
      ;Y  ;Spri ;Pal ;X
.byte $70, $01, $01, $64    ;First Pos
.byte $70, $02, $01, $6C
.byte $78, $11, $01, $64
.byte $78, $12, $01, $6C

.byte $70, $03, $01, $76    ;Second Pos
.byte $70, $04, $01, $7E
.byte $78, $13, $01, $76
.byte $78, $14, $01, $7E

.byte $70, $05, $01, $86    ;Third Poss
.byte $70, $06, $01, $8E
.byte $78, $15, $01, $86
.byte $78, $16, $01, $8E

.byte $70, $07, $01, $98    ;Fourth pos
.byte $70, $08, $01, $A0
.byte $78, $17, $01, $98
.byte $78, $18, $01, $A0

.byte $5E, $21, $01, $98    ;Fifth pos
.byte $5E, $22, $01, $A0
.byte $66, $31, $01, $98
.byte $66, $32, $01, $A0

.byte $5E, $23, $01, $86    ;6th pos
.byte $5E, $24, $01, $8E
.byte $66, $33, $01, $86
.byte $66, $34, $01, $8E

.byte $5E, $25, $01, $76    ;7th pos
.byte $5E, $26, $01, $7E
.byte $66, $35, $01, $76
.byte $66, $36, $01, $7E

.byte $5E, $27, $01, $64    ;8th pos
.byte $5E, $28, $01, $6C
.byte $66, $37, $01, $64
.byte $66, $38, $01, $6C
