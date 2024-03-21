;Assembly program 11
;Call routine
;Accept 2 characters and show them, loop ends when % is accepted in first char
.MODEL small
.STACK 100h
.DATA
msg1 db 13,10, 'Enter 1st char, % to quit : $'
msg2 db 13,10, 'Enter 2nd char : $'
msg3 db 13,10, 'Hit any key to exit $'
crlf db 13,10, '$'
chr1 db 0
chr2 db 0
.CODE
mov AX,@data
mov DS,AX
mainLoop: 
	call getchar1 ; get 1st character
	cmp chr1,'%' ; check if % was accepted
	je exit
	call getchar2 ; get 2nd character
	call show
	jmp mainLoop
exit: lea DX,msg3 ;"Hit any key to quit"
	mov AH,09h
	int 21h
	mov AH,01h ;accept an any character
	int 21h
	mov AH,4ch ;return to operating system
	int 21h
getchar1 proc 
	lea DX,msg1 ;"Enter 1st char :"
	mov AH,09h
	int 21h
	mov AH,01h ; accept char1
	int 21h
	mov chr1,AL
	ret
getchar2:
	lea DX,msg2 ;"Enter 2nd char :"
	mov AH,09h
	int 21h
	mov AH,01h ;accept char2
	int 21h
	mov chr2,AL
	ret
show: 
	lea DX,crlf ;skip to new line
	mov AH,09h
	int 21h
	mov DL,chr1 ;display char1
	mov AH,02h
	int 21h
	mov DL,'-' ;display '-'
	mov AH,02h
	int 21h
	mov DL,chr2 ;display char2
	mov AH,02h
	int 21h
	ret
END