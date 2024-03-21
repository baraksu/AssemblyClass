
.MODEL small
.STACK 100h  


.DATA
clock equ 40h:6ch



.CODE
start:

    mov ax, @data
    mov ds, ax 
         
    mov ah,2ch ; get system timeout.
    int 21h
    
    and dl,00000111b
     
    xor ax,ax
    mov al,dl
    add dl,'0'
    
    

PrintX:
    mov ah,2h
    int 21h
    
        
WeAreDone:    ; end
    mov ax, 4c00h
    int 21h
END start
