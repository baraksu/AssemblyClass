
.STACK 100H

.DATA
NUM1 DW 1234H    ; first number
NUM2 DW 5678H    ; second number
SUM  DW ?        ; result

.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
    
    ; add the two numbers
    MOV AX, NUM1
    MOV AX, [NUM1]
    ADD AX, NUM2
    
    ; store the result in SUM
    MOV SUM, AX
    
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
