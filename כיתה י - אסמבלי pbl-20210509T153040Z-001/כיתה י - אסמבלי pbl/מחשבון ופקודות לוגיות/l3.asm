IDEAL
MODEL small
STACK 100h
jumps
p186

DATASEG
; --------------------------
	entr db "please enter a number: $"
	ten db 10
	my_bits db 0

CODESEG
proc printString
	pusha
	mov ah, 9h
	int 21h
	popa
	ret
endp printString

proc readUserInput
; get user number to al
	mov ah, 1
	int 21h
	sub al, '0'
	ret
endp readUserInput

proc newLine
	pusha
	mov dl, 0ah
	mov ah, 2h
	int 21h
	popa
	ret
endp newLine

proc printNumber
; print the result stored in AL 
	pusha
	mov ah, 0
	div [ten]
	add ax, '00'
	mov dx, ax
	mov ah, 2h
	int 21h
	mov dl, dh
	int 21h
	call newLine	
	popa
	ret
endp printNumber


start:
	mov ax, @data
	mov ds, ax
; --------------------------
	mov dx, offset entr
	call printString
	call readUserInput
	mov [my_bits], al
	or [my_bits], 00100000b
	cmp [my_bits], 0
	
exit:
	mov ax, 4c00h
	int 21h
END start


