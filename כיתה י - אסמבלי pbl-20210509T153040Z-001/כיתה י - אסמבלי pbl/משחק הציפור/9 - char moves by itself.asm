.MODEL small
.STACK 100h
.DATA
; --------------------------
opennengScreen       	db '											    ',10,13 		
						db '											    ',10,13 
						db '											    ',10,13 
						db '											    ',10,13  	   	
						db '		          ________ ______  ___  _______  ___     ',10,13  
						db '		         /_  __/ // / __/ / _ )/  _/ _ \/ _ \   	',10,13
						db '		          / / / _  / _/  / _  |/ // , _/ // /    ',10,13
						db '		         /_/ /_//_/___/ /____/___/_/|_/____/     ',10,13
						db '												',10,13
						db '                           ________   __  _______ 			',10,13
						db '                          / ___/ _ | /  |/  / __/           ',10,13
						db '                         / (_ / __ |/ /|_/ / _/             ',10,13
						db '                         \___/_/ |_/_/  /_/___/             ',10,13
						db 10, 13, 10, 13, '$'
						db '                                             ',10,13
						db '												',10,13,'$'
student					db '				MADE BY: Ayelet Mashiah			',10,13,10, 13, '$'
						db '             Press any key to continue$'

frame 	db 10, 13
		db '          ','THE BIRD GAME ', 10, 13, 10, 13, 10,13
		db '      ',86,86,86,86,86,86,86,86,86,86,86,86,86,86,86,86,86,86,86, 86, 86,10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','>','                   ', '|', 10, 13
		db '      ','|','                   ', '<', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','>','                   ', '|', 10, 13
		db '      ','|','                   ', '<', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '<', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','>','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ','|','                   ', '|', 10, 13
		db '      ',94,94,94,94,94,94,94,94,94,94,94,94,94,94,94,94,94,94,94, 94, 94, 10, 13
		db ' ', 10, 13
		db '$'

; character coordinates
x_coord db 7 	; column
y_coord db 6 	; row

chr db 0
; --------------------------
.CODE

; proint a string on the scree assuming the strig offset is in dx
proc printString
	pusha
	mov ah, 9h 
	int 21h	;interrupt that desplays a string
	popa
	ret
endp printString	

; reads a character into chr
proc readChr
	pusha
	; waits for character
	mov ah, 0h
	int 16h
	mov [chr], al
	popa
	ret
endp readChr

; set cursore position
proc setCursorePosition
	pusha
	mov dh, [y_coord]  ; row
	mov dl, [x_coord]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h	 
	popa
	ret
endp setCursorePosition

; delete character
proc deleteCharacter
	pusha
	; draw blank - ascii 0 at cursor position
	mov ah, 9 
	mov al, 0   	; al = character to display 
	mov bx, 0	  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 	 
	popa
	ret
endp deleteCharacter

; draw character
proc drawCharacter
	pusha
	mov ah, 9 
	mov al, 2   	; aL = character to display 
	mov bx, 00Eh  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 	 
	popa
	ret
endp drawCharacter

; delay to slow down character
proc delay
	pusha
	mov cx, 03h ;High Word
	mov dx, 4240h ;Low Word
	mov al, 0
	mov ah, 86h ;Wait
	int 15h
	popa
	ret
endp delay
	
start:
	mov ax, @data
	mov ds, ax
; --------------------------

;---------------------------------------------------------
	; print openning screen
	mov dx, offset opennengScreen 	;printing the openneig screen string
	call printString		

	; print student name
	mov dx, offset student		 	;printing the studentn string
	call printString

	; waits for character
	call readChr
	
	; clear screen by entering grphic mode
	mov ax, 13h
	int 10h
	
;----------------------------------------------------------------		
	; print game frame
	mov dx, offset frame 	;printing the frame string
	mov ah, 9h 
	int 21h		
	
	; waits for character
	call readChr
	

;-----------------------------------------------------------------	
	; print chararcter
	; set cursore location
	call setCursorePosition
	
	; draw smiley - ascii 2 at cursor position
	call drawCharacter
	
	; waits for character
	call readChr


;------------------------------------------------------------------
	mov cx, 10
	mov [chr], 0
mainGameLoop:
	
	; move charcter by 1 step
	; delete chraracter
	; draw blank - ascii 0 at cursor position
	call deleteCharacter
	
	; increase x_coord by 1	
	inc [x_coord]
	cmp [chr], ' '
	je jmpChr
	add [y_coord], 2
	jmp continue
jmpChr:
	sub [y_coord], 2
continue:
	; print chararcter
	; set cursore location
	call setCursorePosition
	
	; draw smiley - ascii 2 at cursor position
	call drawCharacter
	
	; check if there is a charcter to read
	mov [chr], 0
	mov ah, 1h
	int 16h
	jz noKey
	
	; read a chararcter
	call readChr

	; check if user asks to quit
	cmp [chr], 'q'
	je end_game

noKey:
	call delay
	loop mainGameLoop

end_game:
	; text mode
	mov ax, 2h
	int 10h
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start