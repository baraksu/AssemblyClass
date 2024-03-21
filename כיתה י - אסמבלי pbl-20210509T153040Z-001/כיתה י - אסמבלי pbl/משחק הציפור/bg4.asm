IDEAL
MODEL small
STACK 100h
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

; character coordinates
	x_cord db 7 	; column
	y_cord db 6 	; row
	color  dw 0Eh    ; color
; --------------------------
CODESEG

start:
	mov ax, @data
	mov ds, ax

;---------------------------------------------------------
; print openning screen
	mov dx, offset opennengScreen 	;printing the openneig screen string
	mov ah, 9h 
	int 21h							;interrupt that desplays a string

; print student name
	mov dx, offset student		 	;printing the studentn string
	mov ah, 9h 
	int 21h							;interrupt that desplays a string

; waits for character
	mov ah, 0h
	int 16h
	
; clear screen by entering grphic mode
	mov ax, 13h
	int 10h
;----------------------------------------------------------------		
	; print game frame
	mov dx, offset frame 	;printing the frame string
	mov ah, 9h 
	int 21h		
	
	; waits for character
	mov ah, 0h
	int 16h	
;-----------------------------------------------------------------	
; print chararcter
; set cursore location
	mov dh, [y_cord]  ; row
	mov dl, [x_cord]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
; draw smiley - ascii 2 at cursor position
	mov ah, 9 
	mov al, 2   	; aL = character to display 
	mov bx, [color]  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 
	
; waits for character
	mov ah, 0h
	int 16h	
	
;------------------------------------------------------------------
; move charcter by 1 step
; delete chraracter
; draw blank - ascii 0 at cursor position
	mov [color], 0
	
	mov ah, 9 
	mov al, 0   		; al = character to display 
	mov bx, [color]	  	; bh = Background   bl = Foreground 
	mov cx, 1  			; cx = number of times to write character 
	int 10h 
	
; increase x_coord by 1	
	inc [x_cord]
	mov [color], 2		; change in to color
	
; print chararcter
; set cursore location
	mov dh, [y_cord]  ; row
	mov dl, [x_cord]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
; draw smiley - ascii 2 at cursor position
	mov ah, 9 
	mov al, 2   	; aL = character to display 
	mov bx, [color]  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 
	
	
; waits for character
	mov ah, 0h
	int 16h	
	
; move charcter by 3 steps (y_ccord)
; delete chraracter
; draw blank - ascii 0 at cursor position

	mov [color], 0
	
	mov ah, 9 
	mov al, 0   	; al = character to display 
	mov bx, 0	  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 
	
; increase x_coord by 1	
	add [y_cord],3
	mov [color], 2 	; change in to color
	
; print chararcter
; set cursore location
	mov dh, [y_cord]  ; row
	mov dl, [x_cord]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
; draw smiley - ascii 2 at cursor position
	mov ah, 9 
	mov al, 2   	; aL = character to display 
	mov bx, [color]  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 

; waits for character
	mov ah, 0h
	int 16h	

; check if user asks to quit
	cmp al, 'q'
	je end_game

	
; move charcter by -2 steps (y_ccord) +2 (x_coord)
; delete chraracter
; draw blank - ascii 0 at cursor position
	mov [color], 0
	
	mov ah, 9 
	mov al, 0   	; al = character to display 
	mov bx, [color]	  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 
	
; increase x_coord by 1	
; decrease y_coord by 2
	mov [color], 4
	sub [y_cord], 2
	add [x_cord], 2
	
; print chararcter
; set cursore location
	mov dh, [y_cord]  ; row
	mov dl, [x_cord]  ; column
	mov bh, 0   ; page number
	mov ah, 2
	int 10h
	
; draw smiley - ascii 2 at cursor position
	mov ah, 9 
	mov al, 2   	; aL = character to display 
	mov bx, [color]  	; bh = Background   bl = Foreground 
	mov cx, 1  		; cx = number of times to write character 
	int 10h 
	
; waits for character
	mov ah, 0h
	int 16h	

; text mode
	mov ax, 2h
	int 10h
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start