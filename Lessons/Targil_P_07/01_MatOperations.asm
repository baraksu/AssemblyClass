;ver 101
.MODEL small
.STACK 100h

.DATA
p1 db 1h
p2 db 2h
p3 dw 3h
arry  db 4,4,4,4,4,4,4,4,4,4

.CODE
start:

    mov ax, @data
    mov ds, ax  
    
    xor ax,ax
    mov bx, offset p2
    
    ; add
    add p1,1h
    add ax,2h
    add al,[1]
    add al,[bx+ 1]
    
    ;sub
    sub [bx],1h
    
    ;inc
    inc ax
    inc [bx]
    neg [bx]
    
    ; mul
    mov ax,10h
    mov bx,10h
    
    mul bl ; result ax=al*bl
    
    mov ax,1000h
    mul bx; result dx:ax = ax* bx
            
    mov ax,10h 
    mov bx,1
    mul [byte ptr bx]  
    
    ; mul(unsign) vs imul(unsign) 
    mov ax, 0
    mov bl, 00000010b
    mov al, 11111011b
    mul bl   ;251*2
    mov ax, 0
    mov al, 11111011b
    imul bl ;-5*2  
    
    ;div
    mov ax,9
    mov bx, 2
    div bl ;al= ax div bl, ah= ax mov bl
    
    mov ax,9
    mov bx,2
    div bx ; ax= dx:ax div bx, dx=dx:ax mod bx 
     
    ; arry
    mov bx, offset arry
	mov si,0
	add [byte ptr bx+si], 2h
	inc si
	add [byte ptr bx+si],2h
        
    ; end
    mov ax, 4c00h
    int 21h
END start
