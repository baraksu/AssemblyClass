IDEAL
MODEL small
STACK 100h
jumps
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
	direction  db 'r'
	fence_x_cord db 5
	fence_y_cord db 5
	tav db '|'
	rnd db 0
	bx_saver dw 0
	obstacle db '<'
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
	cmp [screenChr], '<'
	je youLost
	cmp [screenChr], '>'
	je youLost
	cmp [screenChr], 86  ;V
	je youLost
	cmp [screenChr], 94   ;^
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

proc changeDir
	pusha
	cmp [direction], 'r'
	je left
	mov [direction], 'r'
	add [x_cord], 2
	call draw_Left_Fence
	jmp endChangeDir
left:
	call draw_Right_Fence
	mov [direction], 'l'
	sub [x_cord], 2
	
endChangeDir:
; sets character position in oposit direction
	call setCursorePosition
	popa
	ret
endp changeDir

proc calculateCords
	pusha
	; increase x_coord by 1	
	cmp [direction], 'r'
	je right
	dec [x_cord]
	jmp calc_y
right:
	inc [x_cord]
calc_y:
	cmp [chr], ' '
	je jmpChr
	add [y_cord], 2
	jmp endCalculateCords
jmpChr:
	sub [y_cord], 2
endCalculateCords:
	popa
	ret
endp calculateCords

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
	mov dl, [obstacle]
	mov [tav], dl
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

proc draw_Left_Fence 
	pusha
	mov [fence_x_cord] , 6
	mov [fence_y_cord], 5
	mov [obstacle], '>'
	call draw_fence
	popa
	ret
endp draw_Left_Fence

proc draw_Right_Fence 
	pusha
	mov [fence_x_cord], 26
	mov [fence_y_cord], 5
	mov [obstacle], '<'
	call draw_fence
	popa
	ret
endp draw_Right_Fence



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
;	mov cx, 20
	
mainGameLoop:

; delete chraracter  => draw blank - chraracter at cursor position
	mov [color], 0
	call drawCharacter

; set cursor  location and direction
	call calculateCords
	call setCursorePosition

; check character at cursor location
	call readScreenChr
	call checkScrnChr
	
	cmp [lost], 1
	je end_game
; draw smiley - ascii 2 at cursor position 
	mov [color], 0Eh
	call drawCharacter

; check if thre is a character to read
	mov [chr], 0
	mov ah, 1h
	int 16h
	jz noKey

; read a character
	call readChr

; check if user asks to quit
	cmp [chr], 'q'
	je end_game

noKey:
	call delay
	call delay
	jmp mainGameLoop
;	loop mainGameLoop


end_game:
; text mode
	mov ax, 2h
	int 10h
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start