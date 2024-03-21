;Accept a string up to 100 characters and show it
.MODEL small 
.STACK 100h 
.DATA
msg1 db 13,10,'Enter a string up to 100 characters : $' 
msg2 db 13,10,'The string accepted is: $' 
msg3 db 13,10,'Hit any key to exit',13,10,'$' 
str db 100 
strlen db 0 
strtxt db 100 dup(0) 
char db 0 
.CODE 
 mov AX, @data 
 mov DS, AX 
 lea DX,msg1 ;Show msg1 
 mov AH,09h 
 int 21h  
 
 lea DX,str ;Accept a string 
 mov AH,0ah 
 int 21h  
 
 lea DX,msg2 ;Show msg2 
 mov AH,09h 
 int 21h 
 
 mov AX,0 ;put $ at the end of accepted string 
 mov AL,strlen 
 lea BX,strtxt 
 add BX,AX 
 mov [BX],'$' 
 lea DX,strtxt ;Show acceped string 
 mov AH, 09h 
 int 21h 

 lea DX,msg3 ;Show msg3 on screen 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 

exit: mov AH, 4Ch ;End program 
 int 21h
END 