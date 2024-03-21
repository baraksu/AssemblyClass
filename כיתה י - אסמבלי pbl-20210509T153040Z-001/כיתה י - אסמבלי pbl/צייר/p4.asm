
.MODEL small
.STACK 100h



.DATA
; --------------------------
	x_coordinate  dw ?	; place in line
	y_coordinate dw ?	; place in column
	color  dw 2, 3, 4, 14, 15

	x_begin  dw 0		; Starting point on line
	y_begin  dw 25, 50, 75, 100, 125		; Starting point on column
	x_count  db 35		; loop count line draw
	Y_count  db 25		; loop count column draw

; --------------------------
.CODE

proc drawPixel
; Draw Pixel
	pusha
	xor bh, bh
	mov cx, [x_coordinate]
	mov dx, [y_coordinate]
	mov ax, [color+si]
	mov ah, 0ch
	int 10h
	popa
	ret
	endp drawPixel

Proc	DrawRectangle
; Draw square at x_begin, y_begin position, size 25*35
	pusha
	mov	[x_count],35  		; Square width
	mov [Y_count],25  		; Square height
	mov ax,[x_begin]  		; Save begin point on X
	mov [x_coordinate], ax
	mov ax, [y_begin+si]		; Save begin point on Y
	mov [y_coordinate], ax
line_loop:
; line of dots on screen
	call drawPixel
	inc [x_coordinate]	; Position the next pixel one step to the left
	dec [x_count]
	cmp [x_count], 0  	; Check if the end of the line loop
	jnz line_loop
	
	mov ax, [x_begin]		; Reset line counters
	mov	[x_coordinate], ax
	mov [x_count], 35		; Reset column counters
	inc [y_coordinate]		; Position the next pixel one step down
	dec [y_count]
	cmp [y_count], 0  ; Check if the end of the column loop
	jnz line_loop
	
	popa
	ret
endp DrawRectangle	

	
start:
	mov ax, @data
	mov ds, ax
; --------------------------
;  enter grafic mode 320 * 200 pixels 256 colors
	mov ax, 13h
	int 10h

; Drawing color squares
	mov cx, 5
	mov si, 0
colorLoop:
	call DrawRectangle
	add si, 2
	loop colorLoop

; ====================  End color palette drawing  ============

; Boot mouse
	mov ax, 0h
	int 33h
	
; The mouse is visible
	mov ax, 1h 
	int 33h

	
; Wait for Mouse
waitMS:
	mov ax,3h
	int 33h
	cmp bx, 01h 	; if Left click
	jne waitMS
	
; Draw one pixel in Mouse place
	shr cx,1 ; Adjust location div in 2 -> line
	sub dx, 2 ; sub 2 to see pixel  -> column
	mov bh,0h
	mov ax,[color]
	xor bh, bh
	mov ah,0Ch
	int 10h


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


