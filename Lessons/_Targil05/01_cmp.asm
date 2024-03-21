
.STACK 100H

.DATA


.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
       
    MOV AL, -1
    MOV bL, -3
    sub al, bl
    
    ; add the two numbers
    MOV AL, 10000001b
    MOV bL, 1b
    sub al, bl
    
      
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
     
     