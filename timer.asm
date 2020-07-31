org 100h
jmp start

timer1:
push es
push ax
push bx
push di
push cx
push dx
inc word [cs:count]
call print

mov al,0x20
out 0x20,al
pop dx
pop cx
pop di
pop bx
pop ax
pop es
iret

print:
mov ax,0xb800
mov es,ax
xor di,di
mov cx,4
mov dx,[cs:count]
	inloop:
	mov bx,dx
	mov ax,0xf000
	and bx,ax
	shr bx,12
	mov ah,0x07
	mov al,[cs:arr+bx]
	mov [es:di],ax
	inc di 
	inc di
	shl dx,4
loop inloop
ret


arr: db'0123456789ABCDEF'
count: dw 0x0000

start:
xor ax,ax
mov es,ax
mov di,32
cli
mov word [es:di],timer1
inc di
inc di
mov [es:di],cs
sti

mov dx,start
add dx,15
shr dx,4
mov ax,0x3100
int 21h
