
.MODEL small
.STACK 100h


.DATA
; --------------------------
	x_coordinate dw 100
	y_coordinate dw 50
	color dw 11
	len dw 50
; --------------------------
.CODE

proc drawPixel
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
endp drawPixel
	
proc drawHorizontalLine
; Draw Horizontal line of pixcels
	pusha
	mov cx,[len]
HorizontalLine:
	call drawPixel
	inc [x_coordinate]
	loop HorizontalLine
	popa
	ret
endp drawHorizontalLine

proc drawVerticalLine
; Draw Vertical line of pixcels
	pusha
	mov cx, [len]
drawColum:
	call drawPixel
	inc [y_coordinate]
	loop drawColum
	popa
	ret
endp drawVerticalLine

start:
	mov ax, @data
	mov ds, ax
; --------------------------
;  enter grafic mode 320 * 200 pixels 256 colors
	mov ax, 13h
	int 10h

	call drawHorizontalLine
	call drawVerticalLine
	
	mov [x_coordinate], 100
	mov [y_coordinate], 50
	
	call drawVerticalLine
	call drawHorizontalLine
	
	
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


