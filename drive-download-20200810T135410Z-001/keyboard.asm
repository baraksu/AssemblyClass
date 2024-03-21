; -----------------------------------------------------
; Identify ESC key press and key release
; Print "Start" when a key is pressed
; Print "Stop" when the key is released
; -----------------------------------------------------

.MODEL small
.STACK 100h
.DATA
msg1 db 'Start ESC',13,10,'$'
msg2 db 'Stop ESC',13,10,'$'
saveKey db 0
.CODE
start:
mov ax, @data
mov ds, ax
WaitForKey:
	;check if there is a a new key in buffer
	in al, 64h
	cmp al, 10b
	je WaitForKey
	in al, 60h	
	cmp al, [saveKey]  ;check if the key is same as already pressed
	je WaitForKey
	mov [saveKey], al  ;new key - store it
	cmp al, 1h 
	je KeyPressed
	cmp al, 81h 
	je KeyReleased
	jmp WaitForKey
	
	
KeyPressed:
	;print "Start"
	mov dx, offset msg1
	jmp print
KeyReleased:
	;print "Stop"
	mov dx, offset msg2
print:
	mov ah, 9h
	int 21h
	jmp WaitForKey

exit:
	mov ax, 4c00h
	int 21h
	END start