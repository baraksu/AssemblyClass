
.STACK 100H

.DATA
NUM1 DB 0c8H    ; first number
NUM2 DB 04H    ; second number
SUM  DW ?        ; result

.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
    
    ; add the two numbers
    MOV AL, NUM1
    MOV AL, NUM2
    MOV BL, NUM2
    
    ; store the result in SUM
    MUL BL
    
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
