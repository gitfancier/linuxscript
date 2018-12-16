;LOADER_BASE_ADDR equ 0XA00
;LOADER_START_DECTOR equ 0x2
;----------------------------------
%include "boot.inc"
SECTION MBR vstart=0x7c00
	mov ax,cs
	mov ds,ax
	mov es,ax
	mov ss,ax
	mov fs,ax
	mov sp,0x7c00
	mov ax,0xb800
	mov gs,ax
;clean scream
;use x06
;----------------------------------------
;input
;AH num-0x06
;HL=lin num(if 0 all)
;BH=attribute 
;s(CL,CH) window top left (x,y) location
;(DL,DH) window bottom right (x,y) location
;no return value
	mov ax,0x0600
	mov bx,0x0700
	mov cx,0x0000
	mov dx,0x184f

	int 10h
	mov byte [gs:0x00],'1'
	mov byte [gs:0x01],0xA4
	
	mov byte [gs:0x02],' '
	mov byte [gs:0x033],0xA4

	mov byte [gs:0x04],'M'
	mov byte [gs:0x05],0xA4

	mov byte [gs:0x06],'B'
	mov byte [gs:0x07],0xA4

	mov byte [gs:0x08],'R'
	mov byte [gs:0x09],0xA4

	mov eax,LOADER_START_SECTOR
	mov bx,LOADER_BASE_ADDR
	mov cx,1
	call rd_disk_m_16

	jmp LOADER_BASE_ADDR
;---------------READ HARDDISK-------------------
;FUNCTION:read harddisk n sector
rd_disk_m_16:
;---------eax=sector number
;---------bx=write memory address
;---------cx=read sector count
	mov esi,eax
	mov di,cx
;no_1--set sector number--------	
	mov dx,0x1f2
	mov al,cl
	out dx,al
;--recorver ax
	mov eax,esi
;no_2 LBA address store in 0x1f3-0x1f6
	mov dx,0x1f3
	out dx,al
	
	mov cl,8
	shr eax,cl
	mov dx,0x1f4
	out dx,al

	shr eax,cl
	mov dx,0x1f5
	out dx,al

	shr eax,cl
	and al,0x0f
	or al,0xe0
	mov dx,0x1f6
	out dx,al
;--no_3 write read command 0x20 to port 0x1f7
	mov dx,0x1f7
	mov al,0x20
	out dx,al
;--no_4 check harddisk tatus
.not_ready:
	nop
	in al,dx
	and al,0x88
	cmp al,0x08
	jnz .not_ready
;--no_5 read data from 0xqf0
	mov ax,di
	mov dx,256
	mul dx
	mov cx,ax
;
	mov dx,0x1f0
.go_on_ready:
	in ax,dx
	mov [bx],ax
	add bx,2
	loop .go_on_ready
	ret
	
	times 510-($-$$) db 0
	db 0x55,0xaa