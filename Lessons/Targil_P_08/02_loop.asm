
.MODEL small
.STACK 100h  


.DATA
TimesToPrintX db 2


.CODE
start:

    mov ax, @data
    mov ds, ax 
    
    ;init loop
    xor cx, cx ; cx=0
    mov cl, TimesToPrintX ; we use cl, not cx, since TimesToPrintX is byte long
    mov dl, 'x'

PrintX:
    mov ah,2h
    int 21h
    loop PrintX ; cx=cx-1, cmp cx,0;jne 0
    
        
WeAreDone:    ; end
    mov ax, 4c00h
    int 21h
END start
