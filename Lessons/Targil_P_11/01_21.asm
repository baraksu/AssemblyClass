.STACK 100H
.DATA
NAMBER_A DW 0ABCDH 
message db 'Enter a string',10,13,'$'
input db 20,?,21 dup(' ')

.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
       
    ; read char and convert to number 
    xor ax, ax
    mov ah,1
    int 21h ; Read char to al
    
    sub al,30h ; convert to number   
    
    ;read char and conver to Upper
    
    xor ax, ax
    mov ah,1
    int 21h ; Read char to al
    
    mov cl,1h
    shl cl,5 
    not cl
   
    and al,cl; convert to Upper.
    
    ; print char 
    mov dl,'X'
    mov ah,2
    int 21h
    
    ;print string
    mov dx, offset message
    mov ah,9h
    int 21h
    
    ;read string
    mov dx,offset input 
    mov ah, 0Ah
    int 21h  
    
    ;print the input string
    xor bx,bx
    mov bl, input[1]
    mov input[bx+2],'$'
    
    mov dx, offset input + 2
    mov ah,9
    int 21h
    
    
    
      
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
     
     