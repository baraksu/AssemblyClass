
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
    
    mov ax, 1100b
    mov bx, 1010b
    
    and ax,bx ; ax =1000b
    
    mov ax, 1100b
    or ax,bx ;ax ; ax = 1110b
    
    not bx 
    
    ; xor 
    xor ax,ax
    
    mov ax,2
    mov bx ,3
       
    ; replace num  
    ; ax = ax + bx
    ; bx = ax -bx
    ; ax = ax - bx
    
    xor ax,bx ;ax= ax+bx ; ax = sum
    xor bx,ax ;bx= bx+ax
    xor ax,bx ;ax =ax,bx
    
    
                 
               
    
        
    ; end
    mov ax, 4c00h
    int 21h
END start
