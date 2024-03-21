
.MODEL small
.STACK 100h

.DATA 
first_msg db 'First is bigger $'
second_msg db 'Second is begger $'
equal_msg db 'Equal $'
p1 db 1h
p2 db 2h
p3 db 3h

.CODE
start:

    mov ax, @data
    mov ds, ax 
    
    xor ax,ax 
    
    mov al,p1     
    ;mov al,p2
    ;mov al,p3
    
    cmp al,2
    
    jg greater
    jl lower
    je equal
    
greater:
    lea dx,first_msg
    jmp print
lower:    
    lea dx,second_msg
    jmp print
equal:
    lea dx,equal_msg
    jmp print
    
print:
    mov AH,09h 
    int 21h     
    
    mov AH, 01h ;Read a character 
    int 21h 
 
    ; end
    mov ax, 4c00h
    int 21h
END start
