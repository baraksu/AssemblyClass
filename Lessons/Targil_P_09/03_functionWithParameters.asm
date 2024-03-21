.MODEL SMALL
.STACK 100h

.DATA  
p1 db 1h
result DW ?

.CODE
; use EQU to define function parameters



ADD_NUMS proc
     
    PUSH BP         ; save BP on stack
    MOV BP, SP      ; set BP to current SP 

    xor AX,AX
        
    
    MOV AX, [bp+6]    ; move num1 into AX
    ADD AX, [bp+ 8]    ; add num2 to AX 
    
    mov bx, [bp+4]
    mov [bx],ax 

    POP BP          ; restore BP from stack
    RET 6           ; return from the function and clean up the stack 
    
ADD_NUMS endp



start:
    MOV AX, @DATA
    MOV DS, AX

    ; pass num1 and num2 as parameters to ADD_NUMS
   
    PUSH 01234h ; call by value
    PUSH 04321h
    PUSH offset result ;call by reference
    
    call ADD_NUMS

    MOV AH, 4Ch
    INT 21h

END start
