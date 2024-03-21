
;Accept a character and show its previous and nenst
.MODEL small
.STACK 100h
.DATA
msg1 db 13,10,'Enter a characters : $'
msg2 db 13,10,'Hit any key to exit',13,10,'$'
char db 0
crlf db 13,10,'$'
.CODE
 mov AX, @data
 mov DS, AX 
 lea DX,msg1 ;Show msg1 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 
 mov char,AL ;put the previous in char 
 dec char 

 lea DX,crlf ;New line 
 mov AH,09h 
 int 21h 

 mov AH,02h ;Show the previous 
 mov DL,char 
 int 21h 

 mov DL,'-' ;Show dash 
 int 21h 

 inc char ;Show current char 
 mov DL,char 
 int 21h 

 mov DL,'-' ;Show dash 
 int 21h 

 inc char ;Show next character 
 mov DL,char 
 int 21h 

 lea DX,msg2 ;Show msg3 on screen 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 

exit: mov AH, 4Ch ;End program 
 int 21h 

