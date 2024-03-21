Assembly program 04
;Accept a character and show its previous and next
.MODEL small 1
.STACK 100h 2
.DATA 3
msg1 db 13,10,'Enter a characters : $' 4
msg2 db 13,10,'Hit any key to exit',13,10,'$' 5
char db 0 6
crlf db 13,10,'$' 7
.CODE 8
 mov AX, @data 9
 mov DS, AX 10
 lea DX,msg1 ;Show msg1 11
 mov AH,09h 12
 int 21h 13
 mov AH, 01h ;Read a character 14
 int 21h 15
 mov char,AL ;put the previous in char 16
 dec char 17

 lea DX,crlf ;New line 18
 mov AH,09h 19
 int 21h 20

 mov AH,02h ;Show the previous 21
 mov DL,char 22
 int 21h 23

 mov DL,'-' ;Show dash 24
 int 21h 25

 inc char ;Show current char 26
 mov DL,char 27
 int 21h 28

 mov DL,'-' ;Show dash 29
 int 21h 30

 inc char ;Show next character 31
 mov DL,char 32
 int 21h 33

 lea DX,msg2 ;Show msg3 on screen 34
 mov AH,09h 35
 int 21h 36
 mov AH, 01h ;Read a character 37
 int 21h 38

exit: mov AH, 4Ch ;End program 39
 int 21h 40
END