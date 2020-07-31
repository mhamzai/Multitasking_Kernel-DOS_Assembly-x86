org 100h
jmp start
current: dw 0
nexc: dw 0 
pcb :times 32*16 dw 0 
stack: times 32*256 dw 0
coun: db 0
defint21: dd 0
next equ 0
prev equ 1
resume equ 2
axs equ 4
bxs equ 6
cxs equ 8
dxs equ 10
sis equ 12
dis equ 14
bps equ 16
sps equ 18
css equ 20
dss equ 22
ess equ 24
sss equ 26
ips equ 28
flags equ 30

init:
		mov word[cs:current],0
		mov cx,0
		xor ax,ax
	conv:
		mov bx,cx
		shl bx,5
		mov byte[pcb+bx+prev], 0xff
		mov byte[pcb+bx+next], 0xff
		mov word[pcb+bx+axs], 0 
		mov word[pcb+bx+bxs], 0 
		mov word[pcb+bx+cxs], 0 
		mov word[pcb+bx+dxs], 0
		mov word[pcb+bx+sis], 0 
		mov word[pcb+bx+dis], 0 
		mov word[pcb+bx+bps], 0 
		mov word[pcb+bx+css], 0 
		mov word[pcb+bx+dss], 0 
		mov word[pcb+bx+ess], 0
		mov word[pcb+bx+ips], 0
		mov word[pcb+bx+resume], 1	
		mov word[pcb+bx+flags], 0x200 
		mov word[pcb+bx+sss], cs
		mov ax,cx
		inc ax
		shl ax,9
		add ax,stack
		push ax
		dec ax
		dec ax
		dec ax
		dec ax
		mov word[pcb+bx+sps], ax
		pop ax
		dec ax 
		dec ax
		mov bx,ax
		mov word[bx], cs	
		dec ax
		dec ax
		mov bx,ax
		mov word[bx], rmthread
		inc cx
		cmp cx,16
		jne conv
		mov word[pcb+sss], stack
		mov word[pcb+resume], 0x0001
		mov word[pcb+prev], 0
		mov word[pcb+next], 0 
ret

timer:
	push ds
	push bx
	push cs
	pop ds
	
	mov bx, [current] 
	shl bx, 5
	mov word[pcb+bx+axs], ax 
	mov word[pcb+bx+cxs], cx 
	mov word[pcb+bx+dxs], dx 
	mov word[pcb+bx+sis], si 
	mov word[pcb+bx+dis], di 
	mov word[pcb+bx+bps], bp 
	mov word[pcb+bx+ess], es
	pop ax
	mov word[pcb+bx+bxs],ax
	pop ax
	mov word[pcb+bx+dss],ax
	pop ax 
	mov word [pcb+bx+ips],ax
	pop ax
	mov word[pcb+bx+css], ax
	pop ax
	mov word[pcb+bx+flags], ax
	mov word[pcb+bx+sps], sp
	it:
	mov bl,byte[pcb+bx+next]
	xor bh,bh
	mov word[current], bx
	shl bx, 5
	cmp bx,0
	je exithi
	cmp word[pcb+bx+resume],0
	je it
	exithi:
	mov cx, word[pcb+bx+cxs]
	mov dx, word[pcb+bx+dxs] 
	mov si, word[pcb+bx+sis] 
	mov di, word[pcb+bx+dis] 
	mov bp, word[pcb+bx+bps] 
	mov es, word[pcb+bx+ess] 
	mov sp, word[pcb+bx+sps] 
	push word [pcb+bx+flags] 
	push word [pcb+bx+css] 
	push word [pcb+bx+ips] 
	push word [pcb+bx+dss]
	mov al,0x20
	out 0x20,al
	mov ax, [pcb+bx+axs] 
	mov bx, [pcb+bx+bxs] 
	pop ds
	iret
	
	
	ipcb: 
		push cx
		cmp byte[cs:coun],16
		je exit
		cmp ax, 8100h
		je regist
		cmp ax,1100h
		je del
		cmp ax,9103h
		je res
		cmp ax,9102h
		je paus
		pop cx
		cmp ax,4c00h
		je cler
		jmp far [cs:defint21]
		cler:
		jmp idhr
		regist:
		jmp reg
		
		res:
		pop cx
		mov bx,cx
		shl bx,5
		mov word[cs:pcb+bx+resume],1
		iret
		paus:
		pop cx
		mov bx,cx
		shl bx,5
		mov word[cs:pcb+bx+resume],0
		iret
		exit:
		pop cx
		push ax
		pop ax
		iret
		
		del:
		dec byte[cs:coun]
		pop cx
		mov bx,cx
		shl bx,5
		mov al, byte[cs:pcb+bx+prev]
		mov cl, byte[cs:pcb+bx+next]
		mov byte[cs:pcb+bx+prev],0xff
		mov byte[cs:pcb+bx+next],0xff
		and ax,0x00ff
		and cx, 0x00ff
		push ax
		mov ax,bx
		shr ax,5
		inc ax
		shl ax,9
		add ax,stack
		push ax
		dec ax
		dec ax
		dec ax
		dec ax
		mov word[pcb+bx+sps], ax
		pop ax
		dec ax 
		dec ax
		mov bx,ax
		mov word[bx], cs	
		dec ax
		dec ax
		mov bx,ax
		mov word[bx], rmthread
		pop ax
		mov bx,ax
		shl bx,5
		mov byte[cs:pcb+bx+next], cl
		mov bx,cx
		shl bx,5
		mov byte[cs:pcb+bx+prev], al
		push ax
		pop ax
		iret
		
		reg:
		inc byte[cs:coun]
		pop cx
		pop dx
		push cx
		mov cx,0
		check:
		mov bx,cx
		shl bx,5
		mov bl, byte[cs:pcb+bx+next]
		and bx,0x00ff
		cmp bx,0
		je gotit
		inc cx
		cmp cx,16
		jne check
		gotit:
		mov bx,cx
		mov cx,0
		push bx
		
		empt:
		mov bx,cx
		shl bx,5
		mov bl,byte[cs:pcb+bx+next]
		cmp bl,0xff
		je thispcb
		inc cx
		cmp cx,16
		jne empt
		
		thispcb:
		pop bx	
		mov ax,bx
		shl bx,5
		mov byte[cs:pcb+bx+next],cl
		mov bx,cx
		shl bx,5
		pop cx
		mov word[cs:pcb+bx+ips],cx
		mov byte[cs:pcb+bx+next],0
		mov word[cs:pcb+bx+axs], 0 
		mov word[cs:pcb+bx+bxs], 0 
		mov word[cs:pcb+bx+cxs], 0 
		mov word[cs:pcb+bx+dxs], 0
		mov word[cs:pcb+bx+resume],1
		mov byte[cs:pcb+bx+prev],al
		mov cx,dx
		pop dx
		mov word[cs:pcb+bx+css],dx
		mov word[cs:pcb+bx+dss],ds
		mov word[cs:pcb+bx+ess],es
		push dx
		push cx
		push ax
		pop ax
		iret
	idhr:
		cmp byte[cs:coun],0
		je exi
		kepdel:
		mov cx,[cs:pcb+next]
		dec byte[cs:coun]
		mov bx,cx
		shl bx,5
		mov al, byte[cs:pcb+bx+prev]
		mov cl, byte[cs:pcb+bx+next]
		mov byte[cs:pcb+bx+prev],0xff
		mov byte[cs:pcb+bx+next],0xff
		and ax,0x00ff
		and cx, 0x00ff
		push ax
		mov ax,bx
		shr ax,5
		inc ax
		shl ax,9
		add ax,stack
		push ax
		dec ax
		dec ax
		dec ax
		dec ax
		mov word[pcb+bx+sps], ax
		pop ax
		dec ax 
		dec ax
		mov bx,ax
		mov word[bx], cs	
		dec ax
		dec ax
		mov bx,ax
		mov word[bx], rmthread
		pop ax
		mov bx,ax
		shl bx,5
		mov byte[cs:pcb+bx+next], cl
		mov bx,cx
		shl bx,5
		mov byte[cs:pcb+bx+prev], al
		cmp byte[cs:coun],0
		jne kepdel
		exi:
		jmp far [cs:defint21]	
	
rmthread:
mov cx, word[current]
mov ax,1100h
int 21h


ret

start:
call init
xor ax, ax
mov es, ax 

mov  cx, [es:0x21*4]
mov word[cs:defint21],cx
mov  cx, [es:0x21*4+2]
mov word[cs:defint21+2],cx
mov word [es:0x21*4], ipcb
mov [es:0x21*4+2], cs

cli
mov word [es:8*4], timer
mov [es:8*4+2], cs
sti

mov dx, start
add dx, 15
shr dx, 4
mov ax, 0x3100
int 21h
