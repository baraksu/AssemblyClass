name "shapes"   ; output file name (max 8 chars for DOS compatibility) 
 
get_key macro 
       
    local get_key
        
    get_key:
        
        ; check for keystroke in keyboard buffer:
        mov ah, 1
        int 16h
    jz  get_key 
    
    ; remove keystroke from buffer
    mov ah, 0
    int 16h
    ; keystroke stored at al 
endm

print_str macro str 
    push ax
    
    local next_char, stop_printing 
    lea si, str
    next_char:
        mov al, [si]   
        cmp al, 0           
    je  stop_printing 
        mov ah, 0eh
        int 10h 
        inc si
    jmp next_char
    stop_printing:
    
    pop ax
endm 


#org  100h               ; set location counter to 100h
 
    jmp start
    
    coords      dw 0,0,0,0,0 
    colour      dw 00h    
    keystr      dw 0 
    rev_flag    dw 0 
    char_newl   dw 0ah
    ; null-trminated strings
    str1        db  'Instructions:', 0dh, 0ah, 0               
    str2        db  'Key 1 > [1] Rectangle [2] Circle [3] Triangle [4] Star [other] Quit', 0dh, 0ah, 0
    str3        db  'Key 2 > [0-9] Colour', 0dh, 0ah, 0
    str4        db  'Key 3 > For triangle: [0] Normal [1] Reversed', 0dh, 0ah, 0
    str5        db  'Click > Click at two points to draw shape', 0dh, 0ah, 0
    ; wait for keypress    
    xor ah, ah
    int 16h 
     
    start: 
     ;;;;;;;;;;;;;;;;;;; 
     
    mov ah, 0
    mov al, 13h
    int 10h  
    
     push 20
     push 50
     push 100
     push 03 
     call draw_cir
     add sp, 8
     jmp exit_all
     
     
     
     ;;;;;;;;;;;;;;;;;;;
    ;---------------------------------------------
    ; print instructions
    print_str str1
    print_str str2
    print_str str3
    print_str str4
    print_str str5
       
    ; set video mode to 13h - 320x200
    mov ah, 0
    mov al, 13h
    int 10h  
       
    get_key1:
    ;--------------------------------------------- 
    ; key 1; select shape
    get_key                 ; output as char at al
    lea si, keystr
    mov [si], al
    mov [si+1], 0
    
    ;--------------------------------------------- 
    ; key 2; select colour
    get_key             ; output at al
    sub al, '0'         ; char to int
    lea si, colour
    mov [si], al
    mov [si+1], 0
       
    ;---------------------------------------------
    ; key 3; 0 = normal triangle, !0 = reversed
    get_key             ; output at al
    lea si, rev_flag
    mov [si], al
    mov [si+1], 0
    
    xor ax, ax 
    xor bx, bx
    xor si, si 
    
    lea si, coords     
    
    ;---------------------------------------------
    get_click:
        ; wait for click
        ; (x,2*y) output at bx, cx
        ; get 2 clicks in total
            push ax
            
            mov ax,3
            int 33h
            pop ax
         
            cmp bx, 1
        jne get_click
        
        push bx
        
        ; si points at coords
        add si,2
        shr cx, 1        ; cx originaly holds 2*y...
        mov [si], cx     ; store x

        add si,2
        mov [si], dx     ; store y
        
        pop bx
        
        lea ax, coords
        sub ax, si
        neg ax
    
        cmp ax,4 
    jle get_click
    lea si, coords      ; coords = [0, x0, y0, x1, y1] 
    
    ;---------------------------------------------
    cmp [keystr], '1' 
    je  case_rec
    cmp [keystr], '2'
    je  case_cir
    cmp [keystr], '3'
    je  case_tri        
    cmp [keystr], '4'
    je  case_sta
    jmp exit_all       

    ;---------------------------------------------
    exit_all:
    ; wait for keypress    
    xor ah, ah
    int 16h 
    
    ; return to text mode:
    mov ah, 00
    mov al, 03 ;text mode 3
    int 10h 

ret  


case_rec:
    push [si+8]
    push [si+6]
    push [si+4]
    push [si+2] 
    push [colour] 
    call draw_rec 
    add sp, 10
jmp get_key1

case_cir:
    mov ax, [si+6]
    sub ax, [si+2]
    push ax
    push [si+4]
    push [si+2]
    push [colour] 
    call draw_cir
    add sp, 8
jmp get_key1 

case_tri:
    push [colour]
    push [rev_flag]
    mov ax, [si+6]
    sub ax, [si+2]
    push ax
    push [si+4]
    push [si+2]
    call draw_tri
    add sp, 10 
jmp get_key1

case_sta:
    push    [colour]
    mov     ax, [si+6]
    sub     ax, [si+2]
    push    ax
    push    [si+4]
    push    [si+2]
    call    draw_sta
    add     sp, 8
jmp get_key1

; draws a circle given its centre (x0, y0) and
; point (x0 + r, y0), where r is the radius
; method in brief:
; for xi =  x0-r:x0+r {
;	for yi = y0-r:y0+r {
;		if (((xi-x0)^2+(yi-y0)^2) <= r^2) draw(xi, yi)
;	}
; }
; offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;           +4    +6  +8              +10
;draw_cir ( color, x0, y0, signed int rad)
; local vars:
; -2    x0		(y centre)
; -4    y0		(x centre)
; -6    x_start	(x top to start drawing from)
; -8    y_start (y top to start drawing from)
; -10   rad^2
; -12   2*rad
; -14   temp_sum
; -16	external loop ctr

draw_cir proc near
    push bp
    mov bp, sp    
    push bx
    sub sp, 16
    push bx
    
    cmp [bp+10], 0
    jge skip_neg_rad
    neg [bp+10]
    skip_neg_rad:
   
    mov bx, [bp+6]
    sub bx, [bp+10] 
    mov [bp-2], bx  	; x_centre
    sub bx, [bp+10]
    mov [bp-6], bx  	; x_start
     
    mov bx, [bp+8]
    sub bx, [bp+10]
    mov [bp-4], bx  	; y0 (centre)
    sub bx, [bp+10]
    mov [bp-8], bx  	; ystart (top left)
   
    mov ax, [bp+10]
    mul ax
    mov [bp-10], ax 	; rad^2
   
    mov bx, [bp+10]
    add bx, [bp+10]
    mov [bp-12], bx 	; 2*rad   

    mov cx, [bp-12]
    loop4:
       
        mov cx, [bp-12]
        loop3:
        ; draw a pixel  
        mov [bp-16], cx
        push cx
        draw:
            
            
            
            ;push ax
            mov ax,[bp+10] 		; rad
            sub ax, cx
            
            mul ax
            mov [bp-14], ax		; temp sum
            
            mov ax, [bp+10]		; rad
            sub ax, bx
            
            mul ax
            add [bp-14], ax
            
            mov ax, [bp-10]		; rad^2 
            
            add ax,5; by barak
            
            cmp [bp-14], ax		; if inside the disk...
            jg skip
            
            ; add by barak
            sub ax,[bp-14]
            cmp ax,30
            jg skip
           
            
                   
            ; and add by barak
  
	
		    	mov ax, [bp-16]

				push cx
			   
				mov cx, [bp-2]      ; col
				add cx, ax
				mov dx, [bp-4]      ; row
				add dx, bx 
				mov al, [bp+4]      ; colour
				mov ah, 0ch         ; draw pixel INT
				int 10h

            skip:
              
            pop cx
            loop loop3    
    
        dec bx
        cmp bx, 0
    jg loop4
   
    pop bx
    mov sp, bp  
   
    pop bp
    ret  
draw_cir endp   


; draws a rectangle in the frame defined
; by the two clicks captured prevously
; offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;                +4       +6     +8      +10     +12
;draw_rec( int color, int x0, int y0, int x1, int y1)
; locals:
; -2    x_starting (top vertice)  
; -4    width
; -6    y_starting (top vertice)
; -8    height		 

draw_rec proc near
    push bp				; stores ret addr
    mov bp, sp 
    sub sp, 8
    pusha
	
    mov bx, [bp+6]      ; x0
    sub bx, [bp+10]     ; x0-x1
    cmp bx, 0           ; x0<x1
    jl x0_l_x1
    
    ; x0>x1
    mov bx, [bp+10]     ; x1
    mov [bp-2], bx      ; x_starting    =   x1
    sub bx, [bp+6]
    neg bx
    mov [bp-4], bx      ; width
    jmp x_done
    
    
    ; x0<x1
    x0_l_x1:
    mov bx, [bp+6]      ; x0
    mov [bp-2], bx      ; x_st = x0
    sub bx, [bp+10]
    neg bx
    mov [bp-4], bx      ; width
    
    x_done:
            
    mov bx, [bp+8]     ; y1
    sub bx, [bp+12]    ; y1-y0
    cmp bx, 0          ; y1<y0
    jl y0_l_y1
    
    mov bx, [bp+8]      ; y0
    mov [bp-6], bx      ; y_st = y0
    sub bx, [bp+12]
    ;neg bx
    mov [bp-8], bx      ; h
    jmp y_done
    
    ; y0 < y1
    y0_l_y1:
    mov bx, [bp+12]      ; y0
    mov [bp-6], bx      ; y_st = y0
    sub bx, [bp+8]
    mov [bp-8], bx      ; height
 
    y_done:
    
    mov cx, [bp-8]
    loop1:
        push cx 
        mov bx, cx 
        ;neg bx
        mov cx, [bp-4]
        loop2: 
            push cx
            add cx, [bp-2] 		; (c)ol
            mov dx, bx			; row
            add dx, [bp-6]
            sub dx, [bp-8]		
            mov al, [bp+4]      ; colour 00h to 0fh
            mov ah, 0ch         ; draw pixel
            int 10h
            pop cx 
        loop loop2
        pop cx
    loop loop1
    
    popa
    mov sp, bp  
    pop bp
    ret  
draw_rec endp 

jmp get_key1

; draws an  asterisk - an X overlaid on a cross in one loops
; draws an asterisk withing the frame defined
; by the two clicks captured previously
; arg [bp+8] (length) is the horizontal difference between two clicks
;offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;            +4  +6   +8       +10
; draw_stat( x0, y0, length, colour)
; locals:
; -2;   2*length
; -4;   length/2
; -6;   length/4


draw_sta proc near
    
    push bp
    mov bp, sp
    sub sp, 6
    push cx
    
    
    ; make sure [bp+8] is positive
    cmp [bp+8], 0
    jge skip_neg_star
    neg [bp+8]
    skip_neg_star:
    
    mov cx, [bp+8]
    shl cx, 1 
    mov [bp-2], cx 				; 2*length
    pop cx
    
    
    mov bx, [bp+8]
    shr bx, 1
    mov [bp-4], bx      		; length/2 
    
    shr bx, 1
    mov [bp-6], bx
    
    mov cx, [bp+8]
    
    loop5:
        push cx
        row_:
        add cx, [bp+4]  		; (c)ol
        ;sub cx, [bp-4]
        mov dx, [bp+6]	    	; row
        mov al, [bp+10] 		; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel
        int 10h       
        pop cx
        
        mov bx, cx
        push cx
        
        col_:       
        mov cx, [bp+4]			; col
        add cx, [bp-4]
        mov dx, [bp+6]			; row
        add dx, bx
        sub dx, [bp-4]
        mov al, [bp+10]			; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel
        int 10h
        
        
        diag1_:
        mov cx, [bp+4]
        ;sub cx, [bp-4]  
        add cx, bx
        mov dx, [bp+6]
        sub dx, [bp-4]
        add dx, bx 
        mov al, [bp+10]			; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel 
        int 10h 
        
        
        diag2_:
        mov cx, [bp+4]
        ;sub cx, [bp-4]  
        add cx, bx
        mov dx, [bp+6]
        sub dx, bx
        add dx, [bp-4]
        mov al, [bp+10] 		; colour 00 to 0fh
        mov ah, 0ch 			; draw pixel 
        int 10h         
        
        pop cx 
       
        
    loop loop5
     
    
    
    mov sp, bp    
    pop bp
    ret    
    
draw_sta endp   

; given two clicks at points (x0, y0), (x1, y1)
; draws an isosceles triangle
; width is the horizontal difference between 
; the two clicks that had been captured
;			/\
;		       /  \
;		      /    \
;		     /      \
;	(x0,y0)--> +---------+ <--(x1,y1)
;	           <- width ->
; offsets always relative to BP                
; all args and local vars are unsigned int unless otherwise specified
;
;             +4  +6  +8      +10        +12
; draw_tri (  x0, y0, width, rev_flag, int colour) 
; locals:
; -2	halfWidth
; -4	vertice_top	

draw_tri proc near

    push bp
    mov bp, sp
    sub sp, 4
    
    pusha           
   
    mov bx, [bp+8]  
    shr bx, 1
    mov [bp-2], bx			; width/2
    
    mov cx, [bp+8]
    mov [bp-4], 0			; top of triangle 

    loop7:    
    
        cmp cx, [bp-2]
        jg incr   
        dec [bp-4]
        jmp cont
        incr: 
        inc [bp-4]
        jmp cont
        cont: 
        cmp cx, 1
        je exit_triangle
                     
        mov bx, cx				; col
        push cx
        mov cx, [bp-4]
        loop8: 
            mov ax, cx
            cmp [bp+10], '0'
            jne skip_rev:
		neg ax			; orientation downwards
            skip_rev:
            push cx
            ; draw pixel
	    mov cx, bx			; col
            add cx, [bp+4]
            mov dx, ax			; row
            add dx, [bp+6]
            mov al, [bp+12] 	; 16-bit colour
            mov ah, 0ch 		; draw pixel INT
            int 10h 

            pop cx    
        
        loop loop8
        pop cx
        
    loop loop7
    
    exit_triangle:
    popa 
     
    mov sp, bp
    pop bp 
ret               
                  
draw_tri endp
