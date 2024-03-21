
.STACK 100H

.DATA
NAMBER_A DW 0AABBH

.CODE 
proc Print10X
    push cx
    mov cx, 4 ; 4 'X' in each line
PrintXLoop:
    mov dl, 'X'
    mov ah, 2h
    int 21h ; Print the value stored in dl ('X')
    loop PrintXLoop
    pop cx
    ret
endp Print10X


start:
    mov ax, @data
    mov ds, ax
    mov cx, 3 ; 3 lines of 'X       
Row:
    call Print10X
    mov dl, 0ah
    mov ah, 2h
    int 21h ; New line
    loop Row
exit: 
    mov ax, 4c00h
    int 21h

END start
     
     