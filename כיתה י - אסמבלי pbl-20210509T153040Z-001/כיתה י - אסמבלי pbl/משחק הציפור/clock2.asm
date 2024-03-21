IDEAL
MODEL small
STACK 100h
p186

DATASEG
; --------------------------
	number db 0
	ten db 10
	endTime db 0
	lost db 0


CODESEG

proc print_number
; print number to screen ot right corner
	pusha
; set curser om corner
	mov dh, 19  ;row
	mov dl, 35  ;colum
	mov bh, 0  ;page number
	mov ah, 2
	int 10h
	
	mov al, [number]
	mov ah, 0
	div [ten]
	add ax, '00'
	mov dx, ax
	mov ah, 2h
	int 21h
	mov dl, dh
	mov ah, 2h
	int 21h
	popa
	ret
endp print_number

proc calculateEntTime
	pusha
	mov ah, 2ch  ; erad clock
	int 21h
	mov [endTime], dh   ; mov seconds
	cmp [endTime], 0  ; id 0 need to add 59 to get 1 minit
	je add59
	dec [endTime]
	jmp endClaculate
add59:
	add [endTime], 59
endClaculate:	
	popa
	ret
endp calculateEntTime

proc cheeckEndTime
	pusha
	mov ah, 2ch  ; erad clock
	int 21h

	cmp dh, [endTime]
	jne endCheeckEndTime
	mov [lost], 1
endCheeckEndTime:
	mov [number], dh  ; move second to print on screen
	call print_number
	popa
	ret
endp cheeckEndTime


start:
	mov ax, @data
	mov ds, ax
; --------------------------
; enter 40*25 screen
	mov ax, 13h
	int 10h 

	call calculateEntTime
gameLoop:
	call cheeckEndTime
	cmp [lost], 1
	je text_mode
	jmp gameLoop

text_mode:
; enter 80* 25 screen
	mov ax, 2h
	int 10h 
	
exit:
	mov ax, 4c00h
	int 21h
END start


