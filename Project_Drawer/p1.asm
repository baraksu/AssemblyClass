
.MODEL small
.STACK 100h

.DATA
; --------------------------
	x_coordinate dw 20
	y_coordinate dw 50
	color dw 11
; --------------------------
.CODE

proc draePixel
; Draw Pixel
	pusha
	xor bh, bh
	mov cx, [x_coordinate]
	mov dx, [y_coordinate]
	mov ax, [color]
	mov ah, 0ch
	int 10h
	popa
	ret
endp draePixel

start:
	mov ax, @data
	mov ds, ax
; --------------------------
;  enter grafic mode 320 * 200 pixels 256 colors
	mov ax, 13h
	int 10h

	call draePixel
	
; wait for key press
	mov ah, 0h
	int 16h
	
;	return to text mode 80*20
	mov ax, 2
	int 10h
	
	
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


