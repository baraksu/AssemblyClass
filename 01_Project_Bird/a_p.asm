.286
IDEAL
MODEL small
STACK 100h
DATASEG
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

; variables for "fence" drawing
fence_x_coord db 2
fence_y_coord db 2
bx_saver dw 1
rnd db 0
tav db '|'
obstacle db '<'

; time calculation
endTime db 0

; print number varibles
number db 0
ten db 10
; --------------------------
CODESEG

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
	call drawLeftFence
	jmp endChangeDir
left:
	call drawRightFence
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
;------------------------------ Fence -------------------------------
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
	mov bx, 00Fh  ; bh = Background   bl = Foreground 
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
	mov ah,2ch ; get system timeout.
    int 21h
    
	
	mov ax, dx
	xor ax, [bx]
	add [bx_saver], ax
	and al, 0Fh
	mov [rnd], al
	; add th random number 5 since the fence starts at 5
	add [rnd], 5
	popa	
	ret
endp random

; draws frame side with 5 random obstacles
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
	mov dl, [obstacle]
	mov [tav], dl
	; 5 iterations for 5 obstacles
	mov cx, 5
	
drw_obstacles:
	call random
	mov dl, [rnd]
	mov [fence_y_coord], dl
	call fence_cursor_location
	call draw_tav
	loop drw_obstacles
	popa
	ret
endp draw_fence

; sets parameters for left fence
proc drawLeftFence 
	pusha
	mov [fence_x_coord] , 6
	mov [fence_y_coord], 5
	mov [obstacle], '>'
	call draw_fence
	popa
	ret
endp drawLeftFence

; sets parameters for right fence
proc drawRightFence 
	pusha
	mov [fence_x_coord] , 26
	mov [fence_y_coord], 5
	mov [obstacle], '<'
	call draw_fence
	popa
	ret
endp drawRightFence

; calculates the time the game should be ended - 1 minute
; we actually wait 59 seconds to avoid quiting right now
proc calculateEndTime
	pusha
	
	; read cloclk
	mov ah, 2ch 
	int 21h 

	mov [endTime], dh 
	; put seconds in endTime
	cmp [endTime], 0
	jne calc
	mov [endTime], 59 ; in case seconds value is 0 we wait util it is 59
	jmp endCalculateEndTime
calc:
	dec [endTime]
	
endCalculateEndTime:	
	popa
	ret
endp calculateEndTime

proc checkEndTime
	pusha
	
	; read cloclk
	mov ah, 2ch 
	int 21h 

	; put seconds in endTime
	cmp [endTime], dh
	jne endcheckEndTime
	mov [lost], 1
	
endcheckEndTime:
	mov [number], dh
	call printNumber	
	popa
	ret
endp checkEndTime

;print a number on the screen right corner
proc printNumber
pusha
	; sets cursor on  the corner
	mov dh, 19 ; row
	mov dl, 35  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
	mov al, [number]
	mov ah, 0
	div  [ten]				
	add  ax, '00'		
	mov dx, ax
	mov ah, 2h
	int 21h 
	mov dl, dh
	int 21h
	popa
	ret
endp printNumber


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
	call calculateEndTime
	mov [chr], 0
mainGameLoop:
	
	; move charcter by 1 step
	; delete chraracter
	; draw blank - ascii 0 at cursor position
	call deleteCharacter
	
	call calculateCoords
	call checkEndTime
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