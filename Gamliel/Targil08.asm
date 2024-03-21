; Targil 
;Loop - Accept a letter a-z and show all sequence from this letter to z
.MODEL small
.STACK 100h
.DATA
msg1 db 13,10,'Enter a letter a-z : $'
msg2 db 13,10,'Invalid input $'
msg3 db 13,10,'Hit any key to exit $'
crlf db 13,10,'$'
char db 0
.CODE
 mov AX, @data 
 mov DS, AX 
getchar: lea DX,msg1 ;Show msg1 
 mov AH,09h 
 int 21h 

 mov AH, 01h ;Read a letter 
 int 21h 
 mov char,AL 

 cmp char,'a' ;If character is less then 'a' - invalid 
 jb invalid 
 cmp char,'z' ;If character is greater then 'z' - invalid 
 ja invalid 

 lea DX,crlf ;Skip to new line 
 mov AH,09h 
 int 21h 
nextchar: cmp char,'z' ;Check if last char was shown 
 ja exit ;Exit program 
 mov AH,02h ;Put a char to standard output 
 mov DL,char 
 int 21h 

 mov AH,02h ;Put a space after 1st dig 
 mov DL,' ' 
 int 21h 

 inc char ;Put next char 
 jmp nextchar 

invalid: lea DX,msg2 ;Show msg invalid input 

 mov AH,09h 
 int 21h 

 lea DX,crlf ;Skip to new line 
 mov AH,09h 
 int 21h 
 jmp getchar ;Invalid input, try again 

exit: lea DX,msg3 ;Show msg3 on screen 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 

 mov AH, 4Ch ;End program 
 int 21h 
END
