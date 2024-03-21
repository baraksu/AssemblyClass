IDEAL
MODEL small
STACK 100h

DATASEG
	
	num1 db ?
	num2 db ?
	ten db 10
	input_text db "Enter one digit number $"
	sing_text db "Please enter operation sign $"
	add_text db "Addition: $"
	sub_text db "Subtract: $"
	mul_text  db "Multiply: $"
	div_text db 'Division:  $'
	operation db ?
	rem_n db ?
CODESEG

proc print_message
	mov  ah, 9        		; ah=9 - "print string" sub-function		
	int  21h         		; call dos services
	ret
endp print_message

proc new_line
;  new line
	mov dl, 0ah 			; new line 
	mov ah, 2h
	int 21h
	ret
endp new_line

proc get_num
;  get user number input  to al register
	mov ah, 1h				; code for read character (character save to al)
	int 21h					; dos interrupt "do it"
	sub al, '0'
	ret
endp get_num

proc print_al
	mov ah, 0
	div [ten]
	add ax, '00'
	mov dx, ax
	mov ah, 2h
	int 21h
	mov dl, dh
	int 21h
	ret
endp print_al
	

start:
	mov ax, @data
	mov ds, ax

;  print message and get 1st number	
	mov  dx, offset input_text    ; the address of or message in register dx
	call print_message
	call get_num
	mov [num1], al
	call new_line
	
;  print message and get 2st number		
	mov  dx, offset input_text    ; the address of or message in register dx
	call print_message
	call get_num
	mov [num2], al
	call new_line
	
;  print message and get operation	
	mov  dx, offset sing_text    ; the address of or message in register dx
	call print_message
;  get user operation sign 
	mov ah, 1h			
	int 21h	
	mov [operation], al
	call new_line
	
; nevigation to correct operation
	cmp [operation], '+'
	je Add_op
	cmp [operation], '-'
	je Sub_op
	cmp [operation], '*'
	je Mul_op
	cmp [operation], '/'
	je Sub_op
	 
	 
	
; ADD
Add_op:
	mov dx, offset add_text
	call print_message
	mov al, [num1]
	add al, [num2]
	call print_al
	call new_line
	jmp endExp

; SUB
Sub_op:
	mov dx, offset sub_text
	call print_message
	mov al, [num1]
	sub al, [num2]
	call print_al
	call new_line
	jmp endExp

; multiply
Mul_op:
	mov dx, offset mul_text
	call print_message
	mov al, [num1]
	mul [num2]
	call print_al
	call new_line
	jmp endExp
	
Div_op:
	mov dx, offset div_text
	call print_message
	mov ax, 0
	mov al, [num1]
	div [num2]
	mov [rem_n], ah
	call print_al
	
; print remainder
	mov dl, '('
	mov ah, 2
	int 21h
	
	mov al, [rem_n]
	call print_al
	
	mov dl, ')'
	mov ah, 2
	int 21h
	
	call new_line
	
	


	
endExp:
; --------------------------
	exit:
	mov ax, 4c00h
	int 21h
END start