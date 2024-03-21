IDEAL
.MODEL small
.STACK 100h
p186
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
screenChr db 0
lost db 0
direction db 'r'


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

; reads a character fro the screen on cursor location
proc readScreenChr
	pusha
	mov  bl, 0h   	; Page=1
	mov  ah, 08h  	; Read character function  
	int  10h    	;return the character to al
	mov [screenChr], al
	popa
	ret
endp readScreenChr

; check the cotent of scrrenChe.
; if it is one of <>^v ends game
proc checkScrnChr
	pusha

	cmp [screenChr], '<'
	je youLost
	cmp [screenChr], '>'
	je youLost
	cmp [screenChr], 86
	je youLost
	cmp [screenChr], 94
	je youLost
	cmp [screenChr], '|'
	je changeDirection
	jmp endCheckScrnChr
	
youLost:
	mov [lost], 1
	jmp endCheckScrnChr
changeDirection:
	call changeDir
endCheckScrnChr:
	popa
	ret
endp checkScrnChr

; change character directionfro 'r' to 'l'and from 'l' to 'r'
proc changeDir
	pusha
	cmp [direction], 'r'
	je left
	mov [direction], 'r'
	add [x_coord], 2
	jmp endChangeDir
left:
	mov [direction], 'l'
	sub [x_coord], 2
	
endChangeDir:
; sets character position in oposit direction
	call setCursorePosition
	popa
	ret
endp changeDir

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

; increases x_coord by one if direction is 'r' and decreases it if it is 'l'
; increases y_coord by 2 if chr is not ' ' and decreases it by 1 if it is
proc calculateCoords
	pusha
	; increase x_coord by 1	
	cmp [direction], 'r'
	je right
	dec [x_coord]
	jmp calc_y
right:
	inc [x_coord]
calc_y:
	cmp [chr], ' '
	je jmpChr
	add [y_coord], 2
	jmp endCalculateCoords
jmpChr:
	sub [y_coord], 2
endCalculateCoords:
	popa
	ret
endp calculateCoords


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
	mov [chr], 0
mainGameLoop:
	
	; move charcter by 1 step
	; delete chraracter
	; draw blank - ascii 0 at cursor position
	call deleteCharacter
	
	call calculateCoords
	
	; print chararcter
	; set cursore location
	call setCursorePosition
	
	call readScreenChr
	call checkScrnChr
	
	
	cmp [lost], 1
	je end_game

	
	
	; draw smiley - ascii 2 at cursor position
	call drawCharacter
	
	; check if thre is a charcter to read
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
	jmp mainGameLoop

end_game:
	; text mode
	mov ax, 2h
	int 10h
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start