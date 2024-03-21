.MODEL small
.STACK 100h

.DATA

MORSE_TABLE db "10111b", "111010101b", "11101011101b", "1110101b", "1b",
            "101011101b", "111011101b", "1010101b", "101b", "101011111b",
            "111010101b", "10111011101b", "1110111b", "11101b", "111011101b",
            "101110111b", "11101110111b", "1010111b", "10101b", "1b",
            "10101110111b", "101110101b", "111010111b", "10101110101b", "1110111b",
            "11101011101b"

MESSAGE DB "SOS", 0

.CODE

START:

mov ax, @data
mov ds, ax
MOV SI, MESSAGE ; Load message address
NEXT_CHAR:
LODSB ; Load next character into AL
CMP AL, 0 ; Check for end of message
JE END_PROGRAM
CALL CHAR_TO_MORSE ; Convert character to Morse code
CALL DELAY ; Delay between signals
CALL PLAY_MORSE ; Play Morse code sound
JMP NEXT_CHAR ; Process next character

CHAR_TO_MORSE PROC
PUSH AX ; Save AX
PUSH BX ; Save BX
MOV BL, AL ; Copy character to BL
AND BL, 5Fh ; Convert to uppercase
MOV AX, 0 ; Initialize Morse code to 0
CMP BL, 'A'
JB CHAR_TO_MORSE_DONE
SUB BL, 'A'
MOV AH, OFFSET MORSE_TABLE
ADD AH, BL ; Get Morse code address
MOV AL, [AH] ; Load Morse code
CHAR_TO_MORSE_DONE:
POP BX ; Restore BX
POP AX ; Restore AX
RET ; Return from procedure

PLAY_MORSE PROC
PUSH AX ; Save AX
PUSH BX ; Save BX
MOV BL, AL ; Copy Morse code to BL
AND BL, 0Fh ; Mask high nibble
SHR AL, 4 ; Shift low nibble to high nibble
AND AL, 0Fh ; Mask low nibble
MOV AH, 0 ; Initialize delay counter
PLAY_MORSE_LOOP:
TEST BL, 1 ; Check for dot
JE PLAY_MORSE_DASH
CALL DELAY_SOUND
JMP PLAY_MORSE_CONTINUE
PLAY_MORSE_DASH:
CALL DELAY_SOUND_LONG
PLAY_MORSE_CONTINUE:
SHR BL, 1 ; Shift Morse code right
INC AH ; Increment delay counter
CMP BL, 0 ; Check for end of Morse code
JNE PLAY_MORSE_LOOP
CALL DELAY_SOUND ; Delay after character
POP BX ; Restore BX
POP AX ; Restore AX
RET ; Return from procedure

DELAY PROC
PUSH CX ; Save CX
MOV CX, 2000 ; Set delay counter
DELAY_LOOP:
LOOP DELAY_LOOP ; Decrement CX and loop
POP CX ; Restore CX
RET ; Return from procedure

DELAY_SOUND PROC
PUSH CX ; Save CX
MOV CX, 400 ; Set sound duration
DELAY_SOUND_LOOP:
IN AL, 61h ; Turn on speaker
CALL DELAY ; Delay for 1/120 second
IN AL, 61h ; Turn off speaker
LOOP DELAY_SOUND_LOOP ; Decrement CX and loop
POP CX ; Restore CX
RET ; Return from procedure
ENDP DELAY_SOUND



END START
