.model small
.STACK 100H

.DATA
NAMBER_A DW 0ABCDH 
p1 db 12h 
p2 dw 1234h

.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
       
    mov ax, 01234h ; view ss and sp
    push ax 
    
    push 13h; push number or ascii
    
    ;push [p1]; not a word
    push p2
    
    push [NAMBER_A]
 
    
    xor ax,ax
    mov bp,sp 
    
    mov ax,[bp]  ; sp:bp
    mov ax,[bp+2]
    
    
    
    pop ax
    pop NAMBER_A
    pop [NAMBER_A] 
    
    
    
      
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
     
     