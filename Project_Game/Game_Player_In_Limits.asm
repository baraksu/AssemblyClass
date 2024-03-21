
.MODEL small
.STACK 100h

.DATA
memu1 db '   text **** ', 10, 13
	db  '++++++++++++++', 10, 13
	db  '+            +', 10, 13
    db  '+            +', 10, 13
    db  '+            +', 10, 13
    db  '+            +', 10, 13
	db  '++++++++++++++', 10, 13
	db  '   ', 10, 13
	db   'press p to play', 10, 13
	db   'press Esc', 10, 13,'$'

y_row db 4
x_column db 6
color db 11; Light Cyan

.CODE 

proc Cursor_Location
;Place the cursor on the screen
    mov bh, 0
	mov dh, [y_row]  ; in row
	mov dl, [x_column] 
	mov ah, 2 
	int 10h
	ret
endp Cursor_Location 

proc DrawPlayer
    ; draw player in cursor position
    mov ah, 9	 
    mov al, 2	            ;AL = character to display
    mov  bh, 0h	 ;BH=Page
    mov bl, [color]  ; BL =  Foreground 
    mov cx, 1  ; number of times to write character
    int 10h               ; Bois ->  show the character
    ret 
endp DrawPlayer 

proc RightKeyPress
	inc [x_column] 	
	call Cursor_Location   ; move cursor to new place
;check the character on coordinates 
	mov  bh, 0h  		; Page=1
	mov  ah, 08h		;  Read character function  
	int 10h		 ;Return the character value to AL
	cmp al, '+'		
	jne MovePlayerRight  ; Jump to draw player
	dec [x_column]
	call Cursor_Location
	jmp EndRightKeyPress	

MovePlayerRight:
	dec [x_column]     
	call Cursor_Location    ; Return cursor to player position
	mov [color], 0
	call DrawPlayer
	add [x_column], 1
	mov [color], 11
	call Cursor_Location
	call DrawPlayer
EndRightKeyPress:
	ret
endp RightKeyPress

proc LeftKeyPress
	dec [x_column] 
	call Cursor_Location   ; move cursor to new place
;check the character on coordinates 
	mov bh, 0h  		; Page=1	
	mov	ah, 08h	; Read character function  
	int 10h		;return the character value to AL
	cmp al, '+'
	jne MovePlayerLeft  ; draw player
	inc [x_column]
	call Cursor_Location
	jmp EndLeftKeyPress	

MovePlayerLeft: 
	inc [x_column]
	call Cursor_Location
	mov [color], 0
	call DrawPlayer
	sub [x_column], 1
	mov [color], 11
	call Cursor_Location
	call DrawPlayer
EndLeftKeyPress:
	ret
endp LeftKeyPress  

proc UpKeyPress
	dec [y_row] 
	call Cursor_Location   ; move cursor to new place
; Check the character on coordinates 
	mov bh, 0h  		; Page=1
	mov	ah, 08h	; Read character function  
	int 10h		;Return the character value to AL
	cmp al, '+'
	jne MovePlayerUp  ; draw player
	inc [y_row]
	call Cursor_Location
	jmp EndUpKeyPress	

MovePlayerUp: 
	inc [y_row]
	call Cursor_Location
	mov [color], 0
	call DrawPlayer
	sub [y_row], 1
	mov [color], 11
	call Cursor_Location
	call DrawPlayer
EndUPKeyPress:
	ret
endp UpKeyPress
  
proc DownKeyPress
	inc [y_row] 
	call Cursor_Location   ; Move cursor to new place
; Check the character on coordinates 
	mov bh, 0h  		; Page=1
	mov	ah, 08h	; Read character function  
	int 10h		; Return the character value to AL
	cmp al, '+'
	jne MovePlayerDown  ; Draw player
	dec [y_row]
	call Cursor_Location
	jmp EndDownKeyPress	

MovePlayerDown: 
	dec [y_row]
	call Cursor_Location
	mov [color], 0
	call DrawPlayer
	add [y_row], 1
	mov [color], 11
	call Cursor_Location
	call DrawPlayer
EndDownKeyPress:
	ret
endp DownKeyPress
start:

    mov ax, @data
	mov ds, ax 
	
	

    mov al, 03h  ; display mode 25*40
    mov ah, 0
    int 10h     
    
    ; print string to screen
    mov  dx, offset memu1
    mov  ah, 9h
    int  21h
       
    ; cursor
    mov bh, 0
    mov dh, [y_row] 	; Row number
    mov dl, [x_column]    ; Column number
    mov ah, 2 
    int 10h

    ; print ascii player
    mov ah, 9	; Interrupt code 
    mov al, 3	; Character to display -asci code
    mov	bh,0h	; Page - always 0
    mov bl, [color]; BL =  Foreground 
    mov cx, 1	; Number of times to write character 
    int 10h	 ;int 10h Bios
    
    call Cursor_Location
	call DrawPlayer
    
WaitForCharacter:
	mov ah, 0h ; wait for cursor
	int 16h
     
    cmp al, 27 ;Esc
    je TheEnd 
    
    cmp al, 'p'
	je Move
	jmp WaitForCharacter  
	
	
	
	
RightKey:
	call RightKeyPress
	jmp Move  
LeftKey: 
    call LeftKeyPress
    jmp Move 
UpKey:
    call UpKeyPress
    jmp Move
DownKey:
    call DownKeyPress
    jmp Move   
   

Move: 

    ; Check Type Ahead Buffer Status
	mov ah, 1h
	int 16h
	jz Move   ; no key
    ; Wait for char – read character and save it to register al
	mov ah, 0h
	int 16h

    cmp  ah, 4dh ;right
	je RightKey 
	
	cmp	ah, 4bh  ;left
	je LeftKey 
	
	cmp ah, 48h
	je UpKey
	
	cmp ah,50h
	je DownKey

    jmp Move
  
TheEnd:    
    
    mov al, 03h ; display mode 25*80
    mov ah, 0
    int 10h

exit:
   
    
    mov AH,01h
    int 21h
    
    mov AH,4CH
    int 21h
    
    
    
   
END start
