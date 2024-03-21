Assembly program 12
;call routine and move parameter by stack 1

;Showing the triangle 3
;*********
;********
;*******
;******
;*****
;****
;***
;**
;*
.MODEL small 4
.STACK 100h 5
.DATA 6
msg1 db 13, 10, 'Hit any key to exit $' 7
crlf db 13, 10, '$' 8
len db 0 9
mone dw 0 10
.CODE 11
 mov AX, @data 12
 mov DS, AX 13
 mov mone,10 ;set 1st line to 10 asterics 14
nextLine: mov BX, mone 15
 push BX ;push parameter value to stack 16
 call prtLine ;call print line routne 17
 mov BX, mone 18
 dec BX ;decriment num of asterics 19
 mov mone, BX 20
 jnz nextLine ;jump to print next line 21

 lea DX, msg1 ;triangle was printed, exit program 22
 mov AH, 09h 23
 int 21h 24
 mov AH, 01h 25
 int 21h 26

 mov AH, 4ch 27
 int 21h 28
prtLine: pop AX ;pop return address 29
 pop BX ;pop routine parameter - line length 30
 push AX ;push return address 31
 mov len,BL ;get line length 32

 lea DX, crlf ;start new line 33
 mov AH, 09h 34
 int 21h 35

 mov DL, '*' 36
 mov AH, 02h 37
prtChar: int 21h ;display '*' 38
 dec BL 39
 jnz prtChar 40
 ret 41
END 42