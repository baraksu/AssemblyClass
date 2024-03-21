IDEAL
MODEL small
STACK 100h
p186
DATASEG
; --------------------------
num1 db 0
num2 db 0
ten db 10
input_text db 'Enter one digit number:   $'
add_text db 'Addition:  $'
sub_text db 'substraction: $'
mul_text db 'multiplication: $'
div_text db 'divition: $'
tav db 0
; --------------------------
CODESEG
proc printString
	pusha
	mov  ah, 9h        				
	int  21h         
	popa
	ret
endp printString

proc readUserInput
	;  get user first input number to al
	mov ah, 1h			
	int 21h			
	sub al, '0'
	ret
endp readUserInput

proc newLine	
	pusha; new line
	mov dl, 0ah
	mov ah, 2h
	int 21h
	popa
	ret
endp newLine

proc printNumber
	pusha
	; print the result stored in AL 
	mov ah, 0
	div  [ten]	
	add  ax, '00'		
	mov dx, ax
	mov ah, 2h
	int 21h 
	mov dl, dh
	int 21h
	call newLine
	popa
	ret
endp printNumber

proc printTav
	pusha
	mov dl, [tav]  ; print x
	mov ah, 2
	int 21h
	popa
	ret
endp printTav
	

start:
	mov ax, @data
	mov ds, ax
; --------------------------

	mov dx, offset input_text
	call printString
	call readUserInput
	mov [num1], al
	call newLine

	mov dx, offset input_text
	call printString
	call readUserInput
	mov [num2], al
	call newLine	
	
	mov dx, offset add_text
	call printString
	
	; add operation
	mov al, [num1]
	add al, [num2]

	call printNumber

	mov dx, offset sub_text
	call printString
	
	; add operation
	mov al, [num1]
	sub al, [num2]

	call printNumber	
	
	mov dx, offset mul_text
	call printString
	
	; add operation
	mov al, [num1]
	mul [num2]

	call printNumber	
	
	mov dx, offset div_text
	call printString
	
	; add operation
	mov ax, 0
	mov al, [num1]
	div [num2]

	; call printNumber	
	
	mov [tav], al 
	add [tav], '0'
	call printTav
	
	mov [tav], '('
	call printTav
	
	mov [tav], ah
	add [tav], '0'
	call printTav
		
	mov [tav], ')'
	call printTav
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


