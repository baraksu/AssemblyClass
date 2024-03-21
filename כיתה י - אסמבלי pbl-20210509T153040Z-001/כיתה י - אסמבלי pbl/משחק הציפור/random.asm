IDEAL
MODEL small
STACK 100h
p186
DATASEG

	fence_x_coord db 5
	fence_y_coord db 5
	tav db '|'
	rnd db ?
	bx_server dw 0
; --------------------------

CODESEG

proc fence_cursor_location
	pusha
	mov dh, [fence_y_coord] 	; row
	mov dl, [fence_x_coord]   	; column
	mov bh, 0   	; page number
	mov ah, 2
	int 10h
	popa
	ret
endp fence_cursor_location

proc draw_tav
	pusha
	mov ah, 9 
	mov al, [tav]  	; al = character to display 
	mov bx, 00Fh  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h
	popa
	ret
endp draw_tav

proc draw_line
	pusha
	mov cx, 17
	mov [tav], '|'
; draws a line of length 17 starting at fence_x_coord fence_y_coord
line_loop:
	call fence_cursor_location
	call draw_tav
	inc [fence_y_coord]
	loop line_loop
	popa
	ret
endp draw_line

proc random
	pusha
	mov bx, [bx_server]
; put segment number in 
; register es
	mov ax, 40h
	mov es, ax
; mov random number to ax
	mov ax, [es:6ch]
	xor ax, [bx]  ; to get different  number
	add [bx_server], ax   ; change the "xor" address
	and al, 0fh     ; to get random number < 15
	mov [rnd], al	
	popa
	ret
endp random

proc draw_fence
; Draws a line of length 17 starting at fenc_x_coord fence_y_coord 
; The line contains 5 obstacles
	pusha
	call draw_line
	mov [tav], '>'
	mov cx, 5
; Loop for drawing 5 random obstacles
draw_obstacles:

	call random
	mov dl, [rnd]
	add dl, 5    ; add rnd by 5 mo natch the line
	mov [fence_y_coord], dl
	call fence_cursor_location   
	call draw_tav
	loop draw_obstacles
	
	popa
	ret
endp draw_fence

start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Enter Grafic mode 40 * 25
	mov ax, 13h
	int 10h

	call draw_fence

; Waite for charcter
	mov ah, 0h
	int 16h
	
; return to text mode 80*25
	mov ax, 2h
	int 10h
	
	
exit:
	mov ax, 4c00h
	int 21h
END start


