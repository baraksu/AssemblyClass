.MODEL small

.STACK 100h 



.DATA

msg1 db 13,10,'Enter a three characters string: $'

msg2 db 13,10,'The flip of your string is: $'

msgExt db 13,10,'Hit any key to exit',13,10,'$'

str db 4h

strLen db 0

strTxt db = 0,0,0

crlf db 13,10,'$'

.CODE  

mov ax,@data

mov ds,Ax



lea dx,msg1

mov ah,09h

int 21h    



lea dx,str

mov ah,0ah

int 21h



mov bx,dx

add bx,2

mov [bx+3],'$'



mov al,[bx+2]

mov cl,[bx]

mov [bx],al

mov [bx+2],cl



lea dx,msg2

mov ah,09h

int 21h  



mov dx,bx

mov ah,09h

int 21h





lea dx,msgExt

mov ah,09h

int 21h



mov ah,01h

int 21h



exit: mov ah,4ch

int 21h

END