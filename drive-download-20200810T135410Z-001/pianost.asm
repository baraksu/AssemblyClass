
.MODEL small
p186
.STACK 100h
.DATA
x dw 100
y dw 100
color dw 2
message db 13,10,'         My favorite organ', 10, 13,'$'
endMesseage db 13,10,'ESC key pressed',13,10,'$'
returnAdress dw ?
temp dw ?
temp_note dw ?
note dw 11EDh,0FE8h,0E2Bh,0D5Bh,0BE4h,0A98h,96Fh,8E5h ; 1193180 / SomeNumber -> (hex)
.CODE
;======================================
proc Print10X
	push cx
	mov cx,10
	push [x]
PrintXLoop:	
	;Print red dot
	push cx
	push dx	
	mov bh,0h
	mov cx,[x]
	mov dx,[y]	
	mov al,[byte ptr color]
	mov ah,0ch
	int 10h	
	inc [x]
	pop dx
	pop cx		
	loop PrintXLoop
	pop [x]
	pop cx
	ret
endp print10X
;======================================
proc printRectangle	
	mov cx,50
	push [y]
Row:
	call Print10X
	inc [y]
	loop Row
	pop [y]
	ret
endp printRectangle	
;======================================
proc organ
	call printRectangle
	mov cx,8
printOrgan:
    push cx
	call printRectangle
	add [x],20
	pop cx
	loop printOrgan		
	ret
endp organ
;======================================

start:
	mov ax, @data
	mov ds, ax
	;mov di, offset note
	;Grfic mode
	mov ax,13h
	int 10h
	mov dx, offset message ;print header
	mov ah, 9h
	int 21h
	call organ
	WaitForData :
	in al, 64h ; Read keyboard status port
	cmp al, 10b ; Data in buffer ?
	je WaitForData ; Wait until data available
	in al, 60h ; Get keyboard data
	
	jmp WaitForData
	
exit:
	mov ax, 4c00h
	int 21h
END start