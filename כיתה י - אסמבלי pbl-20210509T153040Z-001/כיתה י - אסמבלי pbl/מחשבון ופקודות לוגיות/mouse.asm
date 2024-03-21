IDEAL
MODEL small
STACK 100h
p186
DATASEG
; --------------------------
x_coordinate dw 10
y_coordinate dw 10
color dw 4
len dw 10

x_temp dw ?
y_temp dw ?
; --------------------------
CODESEG

; draws one pixel
proc draw_pixel
	pusha 

	xor bh, bh  ; bh = 0
	mov cx, [x_temp]
	mov dx, [y_temp]
	mov ax, [color]
	mov ah, 0ch
	int 10h


	popa
	ret
endp	draw_pixel

; draws a line of pixels
proc draw_line
	pusha
	; move x_coordinate to x_temp
	mov ax, [x_coordinate]
	mov [x_temp], ax

	mov cx, [len]
draw:
	call draw_pixel
	inc [x_temp]
	loop draw

	popa
	ret 
endp	draw_line	

proc draw_rect
	pusha
	
	mov cx, [len]
	mov ax, [y_coordinate]
	mov [y_temp], ax
rect:
	call draw_line
	inc [y_temp]		; column
	loop rect
	popa
	ret 
endp	draw_rect

start:
	mov ax, @data
	mov ds, ax
; --------------------------
; enter graphic mode
	mov ax, 13h
	int 10h

	; initiate cursor
	xor ax, ax
	int 33h
		
	;show cursor
	mov ax, 1h
	int 33h

MouseLoop: 
	mov ax,3h 	; read mouse status and position	
	int 33h 		 
	cmp bx, 01h 	; check left mouse click
	jne MouseLoop	; if left click not pressed….

	; read cursor location
	mov [x_coordinate], cx
	shr [x_coordinate], 1
	
	mov [y_coordinate], dx
	
	; hide cursor
	mov ax, 2h
	int 33h

	call draw_rect
	
	; wait for character
	mov ah, 1
	int 21h
		
	; back to text mode
	mov ax, 2
	int 10h

; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


