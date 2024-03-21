IDEAL
MODEL small
STACK 100h
p186
DATASEG
; --------------------------
	fence_x_cord db 5
	fence_y_cord db 5
	tav db '|'
	rnd db 0
	bx_saver dw 0
	

CODESEG

proc fence_cursor_location
	pusha
	mov dh, [fence_y_cord]  ; row
	mov dl, [fence_x_cord]  ; column
	mov bh, 0 ; page number
	mov ah, 2
	int 10h	
	popa
endp fence_cursor_location

proc draw_tav
	pusha
	mov ah, 9
	mov al, [tav]
	mov bx, 0fh
	mov cx, 1
	int 10h
	popa
	ret 
endp draw_tav

proc draw_line
	pusha
	mov cx, 17
	mov [tav], '|'
draw_fence_loop:
	call fence_cursor_location
	call draw_tav
	inc [fence_y_cord]
	loop draw_fence_loop
	popa
	ret
endp draw_line

proc random
	pusha
	mov bx, [bx_saver]
;put segment number in regoster es
	mov ax, 40h
	mov es, ax
; mov random number to ax
	mov ax, [es:6ch]
	xor ax, [bx]
	add [bx_saver], ax
	and al, 0fh ; check if number is < 15
	mov [rnd], al
	popa
	ret
endp random

proc draw_fence
	pusha
	call draw_line
	mov [tav], '>'
	mov cx, 5
; loop for drwing random onstacles
drw_obstacles:
	call random
	mov dl, [rnd]
	add dl, 5   ; add the random number 5 since the fence starts at 5
	mov [fence_y_cord], dl
	call fence_cursor_location
	call draw_tav
	loop drw_obstacles	
	popa
	ret
endp draw_fence


start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Enter grafic mode
	mov ax, 13h
	int 10h
	

	call draw_fence
	
	mov ah, 0h
	int 16h
	
	mov ax, 2h
	int 10h
	
exit:
	mov ax, 4c00h
	int 21h
END start


