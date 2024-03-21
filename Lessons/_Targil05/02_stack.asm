
.STACK 100H

.DATA
NAMBER_A DW 0AABBH

.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
       
    mov ax, 0AABBh
    push ax
    
      
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
     
     