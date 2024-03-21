ORG 100h     ; program start address


.DATA
; data section
INPUT_STRING DB 80h, 0Dh, 0Ah, "Enter a string: $"
MORSE_TABLE DB "101010", "010101010", "010101010", "0101010", "10", "0101010", "010101010", "10101010", "1010", "1010101010", "0101010", "101010"

.CODE
     
MORSE_DURATION equ 10h    
MORSE_FREQUENCY equ 20h  
MORSE_PAUSE equ 30h

START:   
  mov ax, @data
  mov ds, ax
  
  mov ah, 0Ah  ; read string input
  mov dx, OFFSET INPUT_STRING
  int 21h
  
  mov si, OFFSET INPUT_STRING  ; initialize string pointer
  mov cx, 0    ; initialize character counter
  
  ; loop through each character in the input string
  morse_loop:
    mov al, [si]   ; load current character
    cmp al, 0      ; check for end of string
    je end_morse   ; if end of string, exit loop
    
    call morse_code ; generate Morse code tone for current character
    inc si          ; increment string pointer
    inc cx          ; increment character counter
    jmp morse_loop  ; repeat for next character
    
  end_morse:
    ret
  
; generate Morse code tone for a given character
morse_code:
  push ax     ; save register values
  push bx
  push cx
  push dx
  push si
  
  mov bx, offset MORSE_TABLE  ; load Morse code table address
  sub si, 'A'                 ; convert character to table index
  mov dx, [bx+si]           ; load Morse code value
  
  ; loop through Morse code dots and dashes
  morse_tone:
    mov cx, MORSE_DURATION  ; set tone duration
    mov bx, MORSE_FREQUENCY ; set tone frequency
    call tone_generator      ; generate tone
    
    mov cx, MORSE_PAUSE      ; set pause duration
    mov bx, 0                ; set pause frequency
    call tone_generator      ; generate pause
    
    shr dx, 1                ; shift Morse code value right by 1
    jnz morse_tone           ; repeat if more dots or dashes remaining
  
  ; restore register values and return
  pop si
  pop dx
  pop cx
  pop bx
  pop ax
  ret
  
; generate a square wave tone using the system timer
tone_generator:
  push ax     ; save register values
  push bx
  push cx
  
  mov ax, bx  ; set timer frequency
  out 43h, al
  mov al, ah
  out 43h, al
  
  mov al, 10110110b ; set timer mode (square wave)
  out 40h, al
  mov al, ah
  out 40h, al
  
  mov cx, dx  ; set tone duration
  mov dx, 40h ; load timer port address
  in al, dx   ; start timer
  and al, 11111110b
  out dx, al
  
  ; wait for tone duration
tone_wait:
    in al, 61h
    test al, 20h
    jz tone_wait
  
  ; stop timer and restore register values
  mov al, 0
  out dx, al
  pop cx
  pop bx
  pop ax
  ret

END START