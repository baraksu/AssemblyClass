.MODEL small
.STACK 100h

.DATA
; --------------------------
	x_cordinate dw 10
	y_cordinate dw 10
	color dw 4
	len dw 10
	x_temp dw ?
	y_temp dw ?
	
	


.CODE

proc draw_pixel
	pusha
	xor bh, bh
	mov cx, [x_temp]
	mov dx, [y_temp]
	mov ax, [color]
	mov ah, 0ch
	int 10h
	popa
	ret
endp draw_pixel

proc draw_line
	pusha
	mov ax, [x_cordinate]
	mov [x_temp], ax
	mov cx, [len]
draw:
	call draw_pixel
	inc [x_temp]
	loop draw
	popa
	ret
endp draw_line

proc draw_rec
	pusha
	mov cx, [len]
	mov ax, [y_cordinate]
	mov [y_temp], ax
rec:
	call draw_line
	inc [y_temp]
	loop rec
	popa
	ret
endp draw_rec

start:
	mov ax, @data
	mov ds, ax
; --------------------------
	mov ax, 13h  ; graphic mode
	int 10h
	
	xor ax, ax   ; initiate cursor
	int 33h
loop1:	

	mov ax, 1h 	;show mouse cursor
	int 33h

MouseLoop:
	mov ax, 3h  ; reade mouse statue and position
	int 33h
	cmp bx, 01h  ; check left mouse click
	jne MouseLoop
	
	mov [color], 0
	call draw_rec
	mov [color], 27
	
;read courser location
	mov [x_cordinate], cx
	shr [x_cordinate], 1
	
	mov [y_cordinate], dx
	
	mov ax, 2h 	;hide mouse cursor
	int 33h
	
	call draw_rec
	
	mov ah, 1h 	;wait for key
	int 16h
	jz loop1
	
	mov ah, 0h
	int 16h
	
	cmp al, 27
	je the_end
	
	jmp loop1
	
the_end:
	mov ax, 2h  ; text mode
	int 10h
	
	
exit:
	mov ax, 4c00h
	int 21h
END start


