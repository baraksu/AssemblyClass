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
	x_cord db 7 		; column
	y_cord db 6 		; row
	color  dw 0Eh    	; color
	cx_keeper dw 10 	; variable to keep cx in loop
	loop_num  db 0
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

; check if user asks to quit
	cmp al, 'q'
	je jump1
	
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

; check if user asks to quit
	cmp al, 'q'
	je jump1

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

help_jump:
	jmp end_help_jump

jump1:
	jmp end_game
end_help_jump:
	
;------------------------------------------------------------------

mainGameLoop:
	
; move charcter by 1 step
; delete chraracter
; draw blank - ascii 0 at cursor position
	mov [color], 0
	
	mov ah, 9 
	mov al, 0   		; al = character to display 
	mov bx, [color]	  	; bh = Background   bl = Foreground 
	mov cx, 1  			; cx = number of times to write character 
	int 10h 
	
; increase x_coord by 1	and y_cord by 2
;	inc [x_cord]
;	add[y_cord], 2
	dec [y_cord] 
	mov [color], 0Eh		; change in to color
	
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
	
	
	inc[loop_num]
;	cmp [loop_num], 10
	cmp [loop_num], 5
	jb mainGameLoop
	

end_game:	
; text mode
	mov ax, 2h
	int 10h
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start