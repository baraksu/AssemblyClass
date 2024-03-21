IDEAL
MODEL small
STACK 100h
DATASEG
arry  db 4,4,4,4,4,4,4,4,4,4
CODESEG
begin:
	mov ax, @data
	mov ds, ax	
	
	mov bx, offset arry
	mov si,0
	add [byte ptr bx+si], 2h
	inc si
	add [byte ptr bx+si],2h
	inc si
	add [byte ptr bx+si], 2h
	inc si
	add [byte ptr bx+si],2h
	inc si
	add [byte ptr bx+si], 2h
	inc si
	add [byte ptr bx+si],2h
	inc si
	add [byte ptr bx+si], 2h
	inc si
	add [byte ptr bx+si],2h
	
	
exit:
	mov ax, 4c00h
	int 21h
END begin


