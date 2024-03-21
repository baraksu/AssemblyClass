
.MODEL small
.STACK 100h

.DATA
p1  db 7h
p2  db 8h
p3  dw 10h

.CODE
start:
    ; init
    mov ax, @data
    mov ds, ax
    
    
    mov ax,1
    shl ax,1
    shl ax ,1
    shr ax ,2
    
        
    ; end
    mov ax, 4c00h
    int 21h
END start
