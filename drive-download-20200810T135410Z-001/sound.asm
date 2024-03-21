
.MODEL small
.STACK 100h
.DATA
returnAdress dw ?
temp dw ?
temp_note dw ?
note dw 11EDh,0FE8h,0E2Bh,0D5Bh,0BE4h,0A98h,96Fh,8E5h ; 1193180 / SomeNumber -> (hex)
.CODE


;======================================
proc closeSpeaker
; close the speaker
	push ax
	in al, 61h
	and al, 11111100b
	out 61h, al
	pop ax
	ret
endp closeSpeaker
;======================================
proc openSpeaker
; open speaker
	pop [returnAdress]
	pop [temp_note]
	push ax
	in al, 61h
	or al, 00000011b
	out 61h, al
	; send control word to change frequency
	mov al, 0B6h
	out 43h, al
	; play frequency 131Hz
	mov ax, [temp_note]
	out 42h, al ; Sending lower byte
	mov al, ah
	out 42h, al ; Sending upper byte
	pop ax
	push [returnAdress]
	ret
endp openSpeaker	
;======================================


start:
	mov ax, @data
	mov ds, ax
	mov di, offset note
	;Grfic mode
	mov ax,13h
	int 10h
	
WaitForData :
	in al, 64h ; Read keyboard status port
	cmp al, 10b ; Data in buffer ?
	je WaitForData ; Wait until data available
	in al, 60h ; Get keyboard data
	cmp al, 10h
	je Qpress	
	cmp al, 90h
	je Qrelease		
	cmp al, 11h
	je Wpress	
	cmp al, 91h
	je Wrelease	
	jmp WaitForData
Qpress: 
    push [note]  
	call openSpeaker	    
	jmp WaitForData
Qrelease:        
	call closeSpeaker
	jmp WaitForData
Wpress: 
    push [note+2]  
	call openSpeaker	    
	jmp WaitForData
Wrelease:        
	call closeSpeaker
	jmp WaitForData
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


