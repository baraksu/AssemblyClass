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
student						db'				MADE BY: Ayelet Mashiah			',10,13,10, 13, '$'
						db'             Press any key to continue$'


; --------------------------
CODESEG

start:
	mov ax, @data
	mov ds, ax
; --------------------------


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
; --------------------------
exit:
	mov ax, 4c00h
	int 21h
END start