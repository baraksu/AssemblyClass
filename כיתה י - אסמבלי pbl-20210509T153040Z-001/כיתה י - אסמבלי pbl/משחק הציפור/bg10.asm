IDEAL
MODEL small
STACK 100h
p186
DATASEG
; --------------------------
opennengScreen       	db'											    ',10,13 		
						db'											    ',10,13 
						db'											    ',10,13 
						db'											    ',10,13  	   	
						db'		          ________ ______  ___  _______  ___     ',10,13  
						db'		         /_  __/ // / __/ / _ )/  _/ _ \/ _ \   	',10,13
						db'		          / / / _  / _/  / _  |/ // , _/ // /    ',10,13
						db'		         /_/ /_//_/___/ /____/___/_/|_/____/     ',10,13
						db'												',10,13
						db'                           ________   __  _______ 			',10,13
						db'                          / ___/ _ | /  |/  / __/           ',10,13
						db'                         / (_ / __ |/ /|_/ / _/             ',10,13
						db'                         \___/_/ |_/_/  /_/___/             ',10,13
						db 10, 13, 10, 13, '$'
						db'                                             ',10,13
						db'												',10,13,'$'
student					db'				MADE BY: Ayelet Mashiah			',10,13,10, 13, '$'
						db'             Press any key to continue$'

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

; character cordinates
	x_cord db 7 	; column
	y_cord db 6 	; row
	color dw 0Eh
	cx_keeper dw 10 ; variable to keep cx in loop
	chr db 0
	screenChr db 0
	lost db 0
; --------------------------
CODESEG

;print string to screen
proc printString
	pusha 
	mov ah, 9h 
	int 21h		;interrupt that desplays a string
	popa
	ret
endp printString
	
	
; reads a character into chr
proc readChr
	pusha
	; waits for character & save it to al
	mov ah, 0h
	int 16h
	mov [chr], al    ; save character to [chr]
	popa
	ret
endp readChr

; set cursore location on y_cord & x_cord
proc setCursorePosition
	pusha
	; set cursore location
	mov dh, [y_cord]  ; row
	mov dl, [x_cord]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	popa
	ret
endp setCursorePosition

; draw character on cursore position
proc drawCharacter
	pusha
	mov ah, 9 
	mov al, 2   	; aL = character to display 
	mov bx, [color]  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 	 
	popa
	ret
endp drawCharacter

; reads a character fro the screen on cursor location
proc readScreenChr
	pusha
	mov  bh, 0h   	; Page=1
	mov  ah, 08h  	; Read character function  
	int  10h    	;return the character to al
	mov [screenChr], al
	popa
	ret
endp readScreenChr

; check the content  of screenChr.
; if it is one of <>^v ends game
proc checkScrnChr
	pusha
	mov [lost], 0
	cmp [screenChr], '<'
	je youLost
	cmp [screenChr], '>'
	je youLost
	cmp [screenChr], 86  ; V
	je youLost
	cmp [screenChr], 94   ; ^
	je youLost
	jmp endCheckScrnChr
youLost:
	mov [lost], 1
endCheckScrnChr:
	popa
	ret
endp checkScrnChr

proc delay
	pusha
	mov cx, 03h   ;High Word
	mov dx, 4240h ;Low Word
	mov al, 0
	mov ah, 86h   ;Wait
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
	call printString						;interrupt that desplays a string

	call readChr
	cmp [chr], 'q'
	je end_game
	
; clear screen by entering grphic mode
	mov ax, 13h
	int 10h
;----------------------------------------------------------------		
; print game frame
	mov dx, offset frame 	;printing the frame string
	call printString	
	
; waits for character
	call readChr

;-----------------------------------------------------------------	
; print chararcter
	
	call setCursorePosition	
	call drawCharacter
	
; waits for character
	mov ah, 0h
	int 16h	

;------------------------------------------------------------------

	mov [chr], 0
	mov cx, 20
	
mainGameLoop:

; delete chraracter  => draw blank - chraracter at cursor position
	mov [color], 0
	call drawCharacter

; increase x_cord by 1	
	inc [x_cord]
	cmp [chr], ' '
	je jmpCar
	add [y_cord], 2
	mov [color], 0Eh
	jmp continue
jmpCar:
	sub [y_cord], 2
continue:

; set cursore location
; draw smiley - ascii 2 at cursor position
	call setCursorePosition	
	call readScreenChr
	call checkScrnChr
	
	cmp [lost], 1
	je end_game
	
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