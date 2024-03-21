; a short program to check how
; set and get pixel color works
.MODEL small
.STACK 100h


.DATA
x dw 1h
y dw 1h
column dw 50
row dw 100 
w equ 16
h equ 4
 
     
.CODE

  
DrawSquare Macro x0,y0,w,h
  LOCAL Draw, DoneColums, DoneColums,doneDraw 

    mov cx,x0
	add cx,w
	
	mov dx,y0
	add dx, h
	
	
Draw: 
	cmp dx,y0 
	jb doneDraw 
	cmp cx,x0
	jb DoneColums
	
    ;mov cx, x  ; column
	;mov dx, y  ; row
	mov al, 15  ; white
	mov ah, 0ch ; put pixel
	int 10h
	
	dec cx
	jmp Draw
	
DoneColums:
	dec dx
	mov cx,x0
	add cx,w
	jmp Draw

doneDraw:
    nop   
ENDM


DrawColumn proc
     
    PUSH BP         ; save BP on stack
    MOV BP, SP      ; set BP to current SP 
    push cx
    push dx

    mov cx, [bp+10]; column
    mov dx, [bp+8];row
    add dx, [bp+6];h
    
    ;mov cx ; column
	;mov dx  ; row
	mov al,byte ptr [bp+4]  ; color
	mov ah, 0ch ; put pixel
NextRow:   
    int 10h
	dec dx       
	cmp dx,[bp+8]
	jnb NextRow   

    pop dx
    pop cx      
    POP BP          ; restore BP from stack
    RET 8           ; return from the function and clean up the stack 
    
DrawColumn endp

start:
	mov ax, @data
    mov ds, ax 
	
	mov ah, 0   ; set display mode function.
	mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
	int 10h     ; set it!
    


DrawSquare column,row,w,h 
 

Redraw:
    ; is key press    
    mov ah,01h
    int 16h
    
    jz Redraw
    ; Get the pressed key
    mov ah,00h
    int 16h
    ; check it is an arrow
    cmp al,0
    jne Redraw
    
    cmp ah,4Dh ;right arrow key 
    je moveRight
    
    cmp ah,4Bh ;left arrow key
    je MoveLeft      

moveRight:
    ; draw the left column with black   
    push column
    push row
    push h
    push 0h; color black
    call DrawColumn
 
 ;Draw Draw the right column with white   
    add column,1
    mov cx, column
    add cx,w
    push cx ;last column
    push row
    push h
    push 0Fh
    call DrawColumn
    
	jmp Redraw
    
MoveLeft:
    nop   
    jmp Redraw
    

exit:
;wait for keypress
  mov ah,00
  int 16h			

  mov AH,4CH
  int 21h

END start

ret