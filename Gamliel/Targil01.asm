;Show a string
.MODEL small
.STACK 100h

.DATA
msg1    db 13,10,"hellow World",13,10,'$'
msg2    db 13,10,'Hit any key to exit',13,10,'$'

.CODE
start:

    mov AX,@data
    mov DS,AX  
    
    lea DX,AX
    mov AH,09h
    int 21h

exit:
    lea DX,msg2
    mov  AH,09h
    int 21h
    
    mov AH,01h
    int 21h
    
    mov AH,4CH
    int 21h
    
    
    
   
END start
