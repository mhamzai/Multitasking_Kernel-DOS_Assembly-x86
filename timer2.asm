org 100h
mov cx,timer1
mov ax,0x8100
int 21h

mov cx,timer2
mov ax,0x8100
int 21h


mov cx,timer3
mov ax,0x8100
int 21h

mov cx,0xffff
loopin:
loop loopin

mov cx,2
mov ax,9102h
int 21h


mov cx,timer4
mov ax,0x8100
int 21h

mov cx,0xffff
loopin1:
loop loopin1

mov ax,1100h
mov cx,4
int 21h

mov ax,1100h
mov cx,1
int 21h

mov ax,1100h
mov cx,2
int 21h

mov ax,1100h
mov cx,3
int 21h


mov ax,0x4c00
int 21h

timer1:
push es
push ax
push bx
push di
push cx
push dx
inc word [cs:count]
call print
pop dx
pop cx
pop di
pop bx
pop ax
pop es
jmp timer1

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


timer2:
push es
push ax
push bx
push di
push cx
push dx
inc word [cs:count]
call print1
pop dx
pop cx
pop di
pop bx
pop ax
pop es
jmp timer2

print1:
mov ax,0xb800
mov es,ax
mov di,152
mov cx,4
mov dx,[cs:count]
	inloop1:
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
loop inloop1
ret

timer3:
push es
push ax
push bx
push di
push cx
push dx
inc word [cs:count]
call print2
pop dx
pop cx
pop di
pop bx
pop ax
pop es
jmp timer3

print2:
mov ax,0xb800
mov es,ax
mov di,140
mov cx,4
mov dx,[cs:count]
	inloop2:
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
loop inloop2
ret



timer4:
push es
push ax
push bx
push di
push cx
push dx
inc word [cs:count]
call print3
pop dx
pop cx
pop di
pop bx
pop ax
pop es
jmp timer4

print3:
mov ax,0xb800
mov es,ax
mov di,120
mov cx,4
mov dx,[cs:count]
	inloop3:
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
loop inloop3
ret





arr: db'0123456789ABCDEF'
count: dw 0x0000



