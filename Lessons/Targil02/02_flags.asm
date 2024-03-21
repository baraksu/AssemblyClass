
.MODEL small
.STACK 100h

.DATA


.CODE
start:

    mov ax, @data
    mov ds, ax
                 


    ; zero flag
    mov al, 4Bh ; 75 decimal
    mov ah, 4Bh ; 75 decimal
    sub al, ah ; subtract al minus ah, result is 0
         
    ; Over Flow (signed -128,127)
    mov al, 64h ; 100 decimal
    mov ah, 28h ; 40 decimal
    add al, ah ; result is 140, out of 8 bit signed range
    
    ;Carry Flag (unsign -,255)      
    mov al, 0C8h ; 200 decimal
    mov ah, 64h ; 100 decimal
    add al, ah ; result is 300, out of 8 bit unsigned range
     
    ;Sign Flag
    mov al ,0h
    sub al , 1h
    
    
        
    ; end
    mov ax, 4c00h
    int 21h
END start
