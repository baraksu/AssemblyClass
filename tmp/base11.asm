IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
arr1 db 22,88,66,44
arr2 db 2,8,6,4
arr3 db 0,0,0,0


; --------------------------
CODESEG
start:
	mov ax, @data
	mov ds, ax
	xor bx,bx
	xor cx,cx
	
	mov bx, offset arr1
	mov ch,[bx]
	mov bx, offset arr2 
	mov cl, [bx]
	sub ch,cl
	mov bx, offset arr3
	mov [bx],ch

	mov bx, offset arr1
	mov ch,[bx+1]
	mov bx, offset arr2 
	mov cl, [bx+1]
	sub ch,cl
	mov bx, offset arr3
	mov [bx+1],ch

	mov bx, offset arr1
	mov ch,[bx+2]
	mov bx, offset arr2 
	mov cl, [bx+2]
	sub ch,cl
	mov bx, offset arr3
	mov [bx+2],ch

	mov bx, offset arr1
	mov ch,[bx+3]
	mov bx, offset arr2 
	mov cl, [bx+3]
	sub ch,cl
	mov bx, offset arr3
	mov [bx+3],ch
; --------------------------
; Your code here
; --------------------------
	
exit:
	mov ax, 4c00h
	int 21h
END start


