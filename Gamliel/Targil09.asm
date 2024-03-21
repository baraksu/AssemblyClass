;Assembly program 09
;Accept string of 20 chracters and show it on screen

.MODEL small
.STACK 100h
.DATA
msg1 db 13, 10, 'Hit any key to exit', 13, 10, '$'
msg2 db 13, 10, 'Enter a string, # to exit', 13, 10, '$'
msg3 db 13, 10, 'The string entered was : $'
outstr db 21 dup(0)
.CODE
	mov AX, @DATA
	mov DS, AX

nextstr: 
	lea DX, msg2 ;Display msg "Enter a 5 chars string"

	mov AH, 09h
	
	int 21h
	
	lea BX,outstr ;Point to output string outstr
	
	mov CL, 1 ;Initialize counter
	
	
	mov AH, 01h

next:
	int 21h ;Accept a character from user
	cmp AL,'#' ;Finish loop and stop program if '#' was accepted
	je exit
	mov [BX], AL ;Put character accepted in the proper position
	inc BX ;Point to next position in output string
	inc CL ;Increase counter
	cmp CL,20 ;Check if all 20 characters entered
	jna next ;If not jump to get the next character
	mov [BX], '$' ;Put the dollar sign at the end of output string
	lea DX, msg3 ;Display "The string entered was : "
	mov AH, 09h ;Display msg "The string entered was :"
	int 21h
	lea DX, outstr ;Display the string entered
	mov AH, 09h
	int 21h
	jmp nextstr ;Jump to get the next string
exit:
	lea DX, msg1 ;Display msg "Hit any key to exit"
	mov AH, 09h
	int 21h
	mov AH, 01h ;Accept any key
	int 21h
	mov AH, 4ch ;Return control to the operating system
	int 21h
END
