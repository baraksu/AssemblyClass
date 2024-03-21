
.MODEL small
.STACK 100h

.DATA
p1 db 1h
p2 db 2h
p3 dw 3h

.CODE
start:

    mov ax, @data
    mov ds, ax 
    
    xor ax,ax 
    
    jmp addFromMemory 
    
    ; add
    add ax,1h
    add ax,2h

addFromMemory:
    add al,[1]
    add al,[bx+ 1]
   
              
    add al,'0' ;ascii
    
    mov dl,al
    mov ah,2h
    int 21h
    
        
    ; end
    mov ax, 4c00h
    int 21h
END start
