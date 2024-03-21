;Accept 20 characters and show it in inverse order

.MODEL small

.STACK 100h

.DATA

array db 21 dup(0)

msg1 db 13, 10, 'Enter 20 characters', 13, 10, '$'

msg2 db 13, 10, 'Display array in inverse order:', 13, 10, '$'

msg3 db 13, 10, 'Hit any key to exit', 13, 10, '$'

crlf db 13, 10, '$'

mone dw 0

temp db 0

.CODE

	mov AX,@DATA
	
	mov DS,AX
	mov mone,1
	lea DX,msg1 ;"Enter 20 characters"
	mov AH,09h
	int 21h
getNextChar: 
	cmp mone,20
	ja showInverse
	mov AH,01h ; Get a character
	int 21h
	lea BX,array ; Insert character in array
	add BX,mone
	mov [BX],AL
	inc mone ; Increase counter
	jmp getNextChar ; Get next character
showInverse: 
	mov mone,20
	lea DX,msg2 ; "Display array in inverse order:"
	mov AH,09h
	int 21h
showNextChar: 
	cmp mone,1
	jb exit
	lea BX,array ; Show a character
	add BX,mone
	mov DL,[BX]
	mov AH,02h
	int 21h
	sub mone,1 ; decrease counter
	jmp showNextChar ; Get next character
exit: 
	lea DX,msg3 ;"Hit any key to exit"
	mov AH,09h
	int 21h
	mov AH,01h ;Get a character
	int 21h
	mov AH,4Ch ;Return control to operating system
	int 21h
END
