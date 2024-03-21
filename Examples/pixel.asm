; a short program to check how
; set and get pixel color works
.MODEL small
.STACK 100h


.DATA
x dw 1h
y dw 1h
column dw 50
row dw 100 
w equ 4
h equ 2
 
     
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

start:
	mov ax, @data
    mov ds, ax 
	
	mov ah, 0   ; set display mode function.
	mov al, 13h ; mode 13h = 320x200 pixels, 256 colors.
	int 10h     ; set it!
    


DrawSquare column,row,w,h 
 

Redraw:
    
    mov ah,01h
    int 16h
    
    jz Redraw
   
    mov ah,00h
    int 16h
    
    cmp al,0
    jne Redraw
    
    cmp ah,4Dh
    je moveRight
    
    cmp ah,4Bh
    je MoveLeft      

moveRight:
   
DeleteLeft:
    mov cx, column
    mov dx, row
    add dx, h

DeleteColumn:   
    ;mov cx, x  ; column
	;mov dx, y  ; row
	mov al, 0  ; white
	mov ah, 0ch ; put pixel
	int 10h
	dec dx       
	cmp dx,row
	jnb DeleteColumn   
    
    
    add cx,w
    add cx,1
    mov dx,row
    add dx,h
    
DrawColumn:   
    ;mov cx, x  ; column
	;mov dx, y  ; row
	mov al, 15  ; white
	mov ah, 0ch ; put pixel
	int 10h
	dec dx       
	cmp dx,row
	jnb DrawColumn
	add column,1   
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