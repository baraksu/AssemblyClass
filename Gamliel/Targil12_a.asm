;Assembly program 
;call routine and move parameter by stack

;Showing the triangle
;*******
;******
;*****
;****
;***
;**
;*
;

.MODEL small
.STACK 100h
.DATA
msg1 db 13, 10, 'Hit any key to exit $'
crlf db 13, 10, '$'
len db 0
mone dw 0 
.CODE 
    mov AX, @data 
    mov DS, AX 
    mov mone,10 ;set 1st line to 10 asterics 
nextLine:
    mov BX, mone 
    push BX ;push parameter value to stack 
    call prtLine ;call print line routne 
    mov BX, mone 
    dec BX ;decriment num of asterics 
    mov mone, BX 
    jnz nextLine ;jump to print next line 
    lea DX, msg1 ;triangle was printed, exit program 
    mov AH, 09h 
    int 21h 
    mov AH, 01h 
    int 21h 
    mov AH, 4ch 
    int 21h 
prtLine proc
    pop AX ;pop return address 
    pop BX ;pop routine parameter - line length 
    push AX ;push return address 
    mov len,BL ;get line length 
    lea DX, crlf ;start new line 
    mov AH, 09h 
    int 21h 
    mov DL, '*' 
    mov AH, 02h 
prtChar: int 21h ;display '*' 
        dec BL 
        jnz prtChar 
        ret 
prtLine endp 
    
END
    