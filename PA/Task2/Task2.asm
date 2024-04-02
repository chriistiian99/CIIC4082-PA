.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
player_x: .res 1
player_y: .res 1
frameCounter: .res 1
speed: .res 1
stateCounter: .res 1  ; New variable to control sprite movement speed
.exportzp player_x, player_y, frameCounter, speed, stateCounter

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

  INC frameCounter

  LDA frameCounter
  CMP speed
  BNE skip_update
  LDA #$00
  STA frameCounter

  ; Update tiles *after* DMA transfer
  JSR update_player

skip_update:
  STA $2005
  STA $2005
  JSR draw_player
  RTI
.endproc

.import reset_handler

.export main
.proc main
  ; Write a palette
  LDX PPUSTATUS
  LDX #$3f
  STX PPUADDR
  LDX #$00
  STX PPUADDR
  load_palettes:
    LDA palettes,X
    STA PPUDATA
    INX
    CPX #$20            ; Updated for new palettes (16dec per palette, 20hex = 32 dec)
    BNE load_palettes

  ; Init counter and speed
  LDA #$00
  STA frameCounter
  LDA #10              ; Initial speed
  STA speed
  LDA #$00
  STA stateCounter     ; Initialize state counter

  ; Write sprite data
  ; NOT USED

vblankwait:             ; Wait for another vblank before continuing
  BIT PPUSTATUS
  BPL vblankwait

  LDA #%10010000        ; Turn on NMIs, sprites use first pattern table
  STA PPUCTRL
  LDA #%00011110        ; Turn on screen
  STA PPUMASK

forever:
  JSR update_player     ; Update player animation based on speed
  JSR draw_player       ; Draw player sprite based on current frame
  JMP forever
.endproc

.proc update_player
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA

  LDA #$01
  STA $0201  ; Update sprite data for sprite 0
  LDA #$02
  STA $0205
  LDA #$11
  STA $0209
  LDA #$12
  STA $020d

  ; Increment state counter
  INC stateCounter

  ; Check state counter to control sprite movement speed
  LDA stateCounter
  CMP #$02            ; Adjust the value as needed for an intermediate state
  BNE skip_state_reset

  ; Reset state counter
  LDA #$00
  STA stateCounter

  ; Decrease speed for slower movement
  DEC speed
  BMI max_speed       ; Ensure speed doesn't go below zero
  JMP update_done

max_speed:
  LDA #10            ; Set maximum speed
  STA speed

skip_state_reset:
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP

update_done:
  RTS
.endproc

.proc draw_player
  ; Save registers
  PHP
  PHA
  TXA
  PHA
  TYA
  PHA           

  LDA #$01
  STA $0201
  LDA #$02
  STA $0205
  LDA #$11
  STA $0209
  LDA #$12
  STA $020d

  ; Write player tile attributes
  ; Use palette 1
  LDA #$01
  STA $0202
  STA $0206
  STA $020a
  STA $020e

  ; Store tile locations
  ; Top left tile:
  LDA player_y
  STA $0200
  LDA player_x
  STA $0203

  ; Top right tile (x + 8):
  LDA player_y
  STA $0204
  LDA player_x
  CLC
  ADC #$08
  STA $0207

  ; Bottom left tile (y + 8):
  LDA player_y
  CLC
  ADC #$08
  STA $0208
  LDA player_x
  STA $020b

  ; Bottom right tile (x + 8, y + 8)
  LDA player_y
  CLC
  ADC #$08
  STA $020c
  LDA player_x
  CLC
  ADC #$08
  STA $020f

  ; Restore registers
  PLA
  TAY
  PLA
  TAX
  PLA
  PLP

  RTS
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "CHR"
.incbin "sprites.chr"

.segment "RODATA"
palettes:
.byte $0f, $07, $17, $37    ; Palette 0 BROWN ; Background Palettes
.byte $0f, $15, $27, $26    ; Palette 1 FIRE
.byte $0f, $38, $39, $3A    ; Palette 2 Light Yellow/Green
.byte $0f, $2A, $2B, $2C    ; Palette 3 GREEN

.byte $0f, $00, $10, $30    ; Palette 0 BLACK/GREY ; Sprite Palettes
.byte $0f, $01, $21, $31    ; Palette 1 BLUE
.byte $0f, $06, $16, $26    ; Palette 2 RED/PINK
.byte $0f, $09, $19, $29    ; Palette 3 GREEN