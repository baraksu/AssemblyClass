;Assembly program 
;Accept two digits and show its produ
.MODEL small
.STACK 100h
.DATA
msg1 db 13,10,'Enter two numbers 0 -9 : $'
msg2 db 13,10,'Invalid Digit $'
msg3 db ' * =   $'
msg4 db 13,10,'Hit any key to exit $'
dig1 db 0
dig2 db 0
char1 db 0 
char2 db 0 
crlf db 13,10,'$' 
.CODE 
 mov AX, @data 
 mov DS, AX 
 lea DX,msg1 ;Show msg1 
 mov AH,09h 
 int 21h 

 mov AH, 01h ;Read 1st digit 
 int 21h 
 mov dig1,AL 

 cmp dig1,'0' ;If character is less then 0 - invalid 
 jb invalid 
 cmp dig1,'9' ;If character is greater then 9 - invalid 
 ja invalid 

 mov AH,02h ;Put a space after 1st dig 
 mov DL,' ' 
 int 21h 
 mov AH, 01h ;Read 2nd digit 
 int 21h 
 mov dig2,AL 

 cmp dig2,'0' ;If character is less then 0 - invalid 
 jb invalid 
 cmp dig2,'9' ;If character is greater then 9 - invalid 
 ja invalid 

 sub dig1,'0' ;Change digit from ascii to binary 
 sub dig2,'0' 
 mov AL,dig1 ;Multiply dig1 by dig2, result in AX 
 mov BL,dig2 
 mul BL 
 mov AH,0 

 mov BL,10 ;Divide result (in AX) by 10, result in AL.
 div BL 

 mov char1,AL ;Put 1st digit of result in char1 
 add char1,'0' 
 mov char2,AH ;Put 2nd digit of result in char2 
 add char2,'0' 

 lea DX,crlf ;Skip new line 
 mov AH,09h 
 int 21h 

 lea BX,msg3 ;Put address of msg3 in BX 
 mov AL,dig1 ;Put dig1 in AL 
 add AL,'0' ;Change dig1 from binary to ascii 
 mov [BX],AL ;Put dig1 in msg3 
 mov AL,dig2 ;Put dig2 in AL 
 add AL,'0' ;Change dig2 from binary to ascii 
 mov [BX+2],AL ;Put dig2 in msg3 
 mov AL,char1 ;Put 1st digit of result in msg3 
 mov [BX+5],AL 
 mov AL,char2 ;Put 2nd digit of result in msg3 
 mov [BX+6],AL 
 lea DX,msg3 ;Show output line msg3 
 mov AH,09h 
 int 21h 
 jmp exit ;Output line was shown, exit program 

invalid: lea DX,msg2 ;Invalid digit 
 mov AH,09h 
 int 21h 

exit: lea DX,msg4 ;Show msg3 on screen 
 mov AH,09h 
 int 21h 
 mov AH, 01h ;Read a character 
 int 21h 
 mov AH, 4Ch ;End program 
 int 21h 
END
