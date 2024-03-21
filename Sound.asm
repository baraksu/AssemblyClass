; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
; Play a note from the speaker
; Author: Barak Gonen 2014
; -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
IDEAL
MODEL small
STACK 100h
DATASEG
note dw 2394h ;; 1193180 / 131 1193180 / 131 --> (hex> (hex))
message db 'Press any key to exit',13,10,'Press any key to exit',13,10,'$'

CODESEG
start:
	mov ax, @data
	mov ds, ax
	; open speaker
	in al, 61h
	or al, 00000011b
	out 61h, al
	; send control word to change frequency
	mov al, 0B6h
	out 43h, al
	; play frequency 131Hz
	mov ax, [note]
	out 42h, al ; Sending lower byte
	mov al, ah
	out 42h, al ; Sending upper byte
	; wait for any key
	mov dx, offset message
	mov ah, 9h
	int 21h
	mov ah, 1h
	int 21h
	; close the speaker
	in al, 61h
	and al, 11111100b
	out 61h, al
exit:
	mov ax, 4C00h
	int 21h
END start