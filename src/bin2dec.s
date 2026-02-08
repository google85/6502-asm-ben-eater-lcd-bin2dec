PORTB = $6000
PORTA = $6001
DDRB = $6002
DDRA = $6003

value = $0200
mod10 = $0202

E  = %10000000
RW = %01000000
RS = %00100000

    .org $8000

reset:
    ldx #$ff        ; initialize stack pointer to #..ff
    txs
    
    lda #%11111111  ; Set all pins on port B to output
    sta DDRB
    
    lda #%11100000  ; Set top 3 pins on port A to output
    sta DDRA
    
    lda #%00111000  ; Set 8-bit mode; 2-line display; 5x8 font
    jsr lcd_instruction
    lda #%00001110  ; Display on; cursor on; blink off
    jsr lcd_instruction
    lda #%00000110  ; Increment and shift cursor; don't shift display
    jsr lcd_instruction
    lda #%00000001  ; Clear display
    jsr lcd_instruction

    ; Initialize value to be the number to convert
    lda number
    sta value
    lda number + 1
    sta value + 1
    
divide:
    ; Initialize the reminder to zero
    lda #0
    sta mod10
    sta mod10 + 1
    clc                 ; clear carry bit
    
    ldx #16
divloop:
    ; Rotate quotient and remainder
    rol value
    rol value + 1
    rol mod10
    rol mod10 + 1
    
    ; a,y = dividend - divisor
    sec
    lda mod10
    sbc #10
    tay                 ; save low byte in Y
    lda mod10 + 1
    sbc #0
    bcc ignore_result   ; branch if dividend < divisor
    sty mod10
    sta mod10 + 1

ignore_result:
    dex
    bne divloop
    rol value           ; shift in the last bit of the quotient
    rol value + 1
    
    lda mod10
    clc
    adc #"0"
    jsr print_char

    ; if value != 0, then continue dividing
    lda value
    ora value + 1
    bne divide          ; branch if value [all 16 bits] not zero

loop:
    jmp loop

number: .word 1729

lcd_wait:
    pha             ; push A value to stack
    lda #%00000000  ; Port B is input
    sta DDRB
lcdbusy:
    lda #RW         ; Read busy flag
    sta PORTA
    lda #(RW | E)
    sta PORTA
    lda PORTB
    AND #%10000000
    bne lcdbusy     ; if not ready
    ; cleanup
    lda #RW         ; Read busy flag
    sta PORTA
    lda #%11111111  ; Port B is output
    sta DDRB
    pla             ; pop A value back from stack
    rts

lcd_instruction:
    jsr lcd_wait
    sta PORTB
    lda #0          ; Clear RS/RW/E bits
    sta PORTA
    lda #E          ; Set E bit to send instruction
    sta PORTA
    lda #0          ; Clear RS/RW/E bits
    sta PORTA
    rts

print_char:
    jsr lcd_wait
    sta PORTB
    lda #RS         ; Set RS; Clear RW/E bits
    sta PORTA
    lda #(RS | E)   ; Set both RS and E bit
    sta PORTA
    lda #RS         ; Clear E bit
    sta PORTA
    rts
    
    .org $fffc
    .word reset
    .word $0000
