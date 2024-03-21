
.MODEL small
.STACK 100h

.DATA


.CODE
start:

    mov ax, 1234h
    mov bx, 0
    mov bl, 34h
    mov cx, 0
    mov ch, 12h

exit:
   
    
    mov AH,01h
    int 21h
    
    mov AH,4CH
    int 21h
    
    
    
   
END start
