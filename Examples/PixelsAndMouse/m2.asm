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
move:
	mov [color], 75
	call draw_rec
	
	mov ah, 0h ; wait for key
	int 16h
	
	cmp al, 27
	je end_game
	
	mov [color], 0
	call draw_rec
	
	add [x_cordinate], 5
	jmp move
	
end_game:
	
	mov ax, 2h  ; text mode
	int 10h
	
	
exit:
	mov ax, 4c00h
	int 21h
END start


