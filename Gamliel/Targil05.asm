;Accept a character a-z and show its upper case 
.MODEL small 
.STACK 100h 
.DATA 
msg1 db 13,10,'Enter a characters a - z : $' 
msg2 db 13,10,'Invalid character $' 
msg3 db 13,10,'Hit any key to exit $' 
char db 0 
.CODE 
 mov AX, @data 
 mov DS, AX 
 lea DX,msg1 ;Show msg1 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 
 mov char,AL 

 cmp char,'a' ;If char < 'a' jump to invalid 
 jb invalid 

 cmp char,'z' ;If char > 'z' jump to invalid 
 ja invalid 
 mov DL,char ;Change letter to upper case 
 add DL,'A' 
 sub DL,'a' 
 mov AH,02H ;Show the uppercase letter 
 int 21h 
 jmp exit 

invalid: lea DX,msg2 ;Show Invalid character 
 mov AH,09h 
 int 21h 

exit: lea DX,msg3 ;Show msg3 on screen 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 
 mov AH, 4Ch ;Return to operating system 
 int 21h 
END 