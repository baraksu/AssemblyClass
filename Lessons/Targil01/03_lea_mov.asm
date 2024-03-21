;Show a string
.MODEL small
.STACK 100h

.DATA
msg1    db 13,10,"hellow World",13,10,'$'
msg2    db 13,10,'Hit any key to exit',13,10,'$'

.CODE
start:
       
    mov bx , @data  
    MOV DS, bx
    MOV Bx, 03h 
    mov ax, 0h
    mov ax, bx+ds
    LEA SI, Bx+Ds  
    
    
    mov AH,4ch
    int 21h
   
END start
