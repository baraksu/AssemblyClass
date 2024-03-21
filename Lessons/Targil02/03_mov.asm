
.STACK 100H

.DATA
NUMS DW 1234H,5678H,0102H,0304H    ; numbers  
X01  DB 'ABCDEFG'


.CODE
start:
    MOV AX, @DATA   ; initialize data segment
    MOV DS, AX
     
     
   ; IN TO REG
    MOV AX, NUMS
    MOV BX, [NUMS]
    LEA CX, NUMS
    
    ;IN TO MEMORY, ONLY WITH B
    MOV BX,1
    MOV [BX],88H   
    MOV [1],99H
    
     
     ; USE SI REGISTER
    MOV SI,1
    MOV AX, [NUMS+SI]
    MOV BX, [NUMS + SI + 1]
    MOV [NUMS + SI + 2],'A'
    MOV [NUMS + SI + 2],'B'
    
    
    
    ; USE CONVERT
    MOV AL, OFFSET X01
    LEA CX, WORD PTR X01
    
    ;USE LEA
    LEA AX, NUMS+ 2
    LEA CX, [X01]
                                      
    
    
    
    ; exit program
    MOV AH, 4CH
    INT 21H
END start
