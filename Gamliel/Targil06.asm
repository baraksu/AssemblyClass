;Accept a character and show a message: Capital letter, Small letter, Digit,Somthing else
.MODEL small 
.STACK 100h 
.DATA 
msg1 db 13,10,'Enter a character : $'
msg2 db 13,10,'Capital letter $'
msg3 db 13,10,'Small letter $'
msg4 db 13,10,'Digit $'
msg5 db 13,10,'Something else $'
msg6 db 13,10,'Hit any key to exit $'
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

 cmp char,'0' ;If character less then 0 : Somthing else 
 jb other 
 cmp char,'9' ;If character is between 0 -9 : Digit 
 jle digit 
 cmp char,'A' ;If '9' < char < 'A' : Other 
 jb other 

 cmp char,'Z' ;Show Capital letter 
 jle upper 
 cmp char,'a' ;If 'Z' < char < 'a' : Other 
 jb other 
 cmp char,'z' ;show Small letter 
 jle lower 
 jmp other ;Show other 

lower: lea DX,msg3 ;Show small letter 
 mov AH,09h 
 int 21h 
 jmp exit 
upper: lea DX,msg2 ;Show capital letter 
 mov AH,09h 
 int 21h 
 jmp exit 
digit: lea DX,msg4 ;Show Digit 
 mov AH,09h 
 int 21h 
 jmp exit 

other: lea DX,msg5 ;Show Somthing else 
 mov AH,09h 
 int 21h 
 jmp exit 
exit: lea DX,msg6 ;Show msg6 on screen 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 
 mov AH, 4Ch ;End program 
 int 21h 
END 