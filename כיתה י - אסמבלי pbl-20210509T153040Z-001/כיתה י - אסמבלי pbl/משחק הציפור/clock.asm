
.MODEL small
.STACK 100h

.DATA
; --------------------------
	number db 0
	ten db 10
	endTime db 0
	lost db 0
; --------------------------
.CODE

proc printNumber
;print a number on the screen right corner
	pusha
; sets cursor on  the corner
	mov dh, 19 ; row
	mov dl, 35  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
; div [number] / 10 -->  result -> al,  remainder -> ah
	mov al, [number]
	mov ah, 0
	div [ten]
; turn digits to ascii
	add ax, '00'
; mov ax to dx and print dl (da = al)
	mov dx, ax
	mov ah, 2h  ; print dl
	int 21h
; mov dh to dx and print dl 
	mov dl, dh
	mov ah, 2h  ; print dl
	int 21h
	popa
	ret
endp printNumber

proc calculateEndTime
	pusha
	mov ah, 2ch 	; read clock
	int 21h
	
	mov [endTime], dh  	;mov Seconds 
	cmp [endTime], 0 	; if 0 we need to add 59 to get to one minit.
	je add59
	dec [endTime]
	jmp endClaculate
add59:
	add [endTime], 59
endClaculate:
	popa
	ret
endp calculateEndTime

proc checkEndTime
	pusha
	mov ah, 2ch
	int 21h
	
	cmp dh, [endTime]
	jne endCheckEndTime
	mov [lost], 1
endCheckEndTime:
	mov [number], dh
	call printNumber
	popa
	ret
endp checkEndTime
	
start:
	mov ax, @data
	mov ds, ax
; --------------------------
; Graphic  mode 320 * 200
	mov ax, 13h
	int 10h

	call calculateEndTime
gameLoop:
	call checkEndTime
	
	cmp [lost], 1
	je text_mode	
	jmp gameLoop
	
text_mode:	
; return to text mode 80*25
	mov ax, 2h
	int 10h
	
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


