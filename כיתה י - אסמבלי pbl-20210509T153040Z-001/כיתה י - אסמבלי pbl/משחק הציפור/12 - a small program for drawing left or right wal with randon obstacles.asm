
.MODEL small
.STACK 100h

.DATA
; --------------------------
fence_x_coord db 2
fence_y_coord db 2
bx_saver dw 1
rnd db 0
tav db '|'
; --------------------------
.CODE
proc fence_cursor_location
	pusha
	mov dh, [fence_y_coord] ; row
	mov dl, [fence_x_coord ]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	popa	
	ret
endp fence_cursor_location

proc draw_tav
	pusha
	mov ah, 9 
	mov al, [tav]   ;AL = character to display 
	mov bx, 00Eh  ; bh = Background   bl = Foreground 
	mov cx, 1  ;cx = number of times to write character 
	int 10h
	popa	
	ret
endp draw_tav

proc random
	; generates a random number and keeps it in rnd
	pusha

	mov bx, [bx_saver]
	; put segment number in 
	; register es
	mov ax, 40h
	mov es, ax
	
	; move random number to ax
	mov ax, es:6Ch
	xor ax, [bx]
	add [bx_saver], ax
	and al, 0Fh
	mov [rnd], al
	popa	
	ret
endp random

proc draw_fence
	pusha
	; draws a line of length 15 starting at fenc__coord fence_y_coord
	; the line contains 5 obstacles
	mov cx, 15
	mov [tav], '|'
	
	; loop for drraing a line
drw_line:
	call fence_cursor_location
	call draw_tav
	inc [fence_y_coord]
	loop drw_line
	

	
	; loop for drwing random onstacles
	mov [tav], '>'
	mov cx, 5
	
drw_obstacles:
	call random
	mov dl, [rnd]
	add dl, 2 ; adding 2 since the fence tarts at line 2
	mov [fence_y_coord], dl
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
	; enter graphic mode
	mov ax, 13h
	int 10h
	
	call draw_fence
	
	; wait for characte
	mov ah, 0h
	int 16h
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


